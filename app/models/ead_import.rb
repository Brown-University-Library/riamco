require "./app/models/ead.rb"

class EadImport
    def initialize(files_path, solr_url)
        @files_path = files_path
        logger = ENV["SOLR_VERBOSE"] == "true" ? Rails.logger : nil
        @solr = SolrLite::Solr.new(solr_url, logger)
        @solr.def_type = "edismax"
    end

    # Deletes all the information for a given EAD ID
    def delete_finding_aid(ead_id)
        query = 'ead_id_s:\"' + CGI.escape(ead_id) + '\"'
        response = @solr.delete_by_query(query)
        return response
    end

    # Imports to Solr the XML files in the path.
    def import_files()
        start_all = Time.now
        Rails.logger.info("Import started: #{Time.now}, path: #{@files_path}")
        errors = []
        files = Dir[@files_path]
        count = files.count
        files.each_with_index do |file_name, ix|
            begin
                start_file = Time.now
                import_one_file(file_name)
                StringUtils.log_elapsed(start_file, "  File: #{File.basename(file_name)} [#{ix+1}/#{count}]")
            rescue => ex
                StringUtils.log_elapsed(start_file, "  Error on file: #{File.basename(file_name)}. #{ex}")
                errors << "File: #{file_name}. #{ex}, #{ex.backtrace}"
            end
        end

        if errors.count == 0
            # Delete any Solr documents that were not touched during the
            # import process.
            #
            # Notice that we use the start time minus 10 seconds just
            # to be safe. We also convert the value to datetime and
            # then to string to make sure it's formatted with the exact
            # format as the timestamp_s value in Solr (including the
            # T to delimit time).
            #
            timestamp = (start_all-10).to_datetime.to_s
            garbage_collect_all(timestamp)
        end

        StringUtils.log_elapsed(start_all, "Import ended")
        return errors
    end

    # Imports to Solr the XML files that have changed
    # since the most recent timestamp in Solr.
    def import_updated()
        timestamp = most_recent_timestamp_in_solr()
        if timestamp == nil
            timestamp = Time.parse("1900-01-01")
        end
        start_all = Time.now
        Rails.logger.info("Import started: #{Time.now}, path: #{@files_path}, timestamp: #{timestamp}")
        errors = []
        count = 0
        Dir[@files_path].each do |file_name|
            begin
                mtime = File.mtime(file_name)
                if mtime > timestamp
                    start_file = Time.now
                    import_one_file(file_name)
                    StringUtils.log_elapsed(start_file, "  File: #{File.basename(file_name)}")
                    count += 1
                end
            rescue => ex
                errors << "File: #{file_name}: #{ex}, #{ex.backtrace}"
            end
        end
        StringUtils.log_elapsed(start_all, "Import ended, #{count} files were imported")
        return {count: count, errors: errors}
    end

    # Parses the XML files in the indicated path and outputs to the console the resulting JSON
    def parse_files()
        errors = []
        puts "["
        Dir[@files_path].each do |file_name|
            begin
                xml = File.read(file_name)
                ead = Ead.new(xml)
                solr_docs = ead.to_solr(true)
                json_docs = solr_docs.map { |solr_doc| solr_doc.to_json }
                puts json_docs.join(", \r\n")
            rescue => ex
                errors << "File: #{file_name}: #{ex}, #{ex.backtrace}"
            end
        end
        puts "]"
        return errors
    end

    private
        # Delete Solr documents older than a given timestamp
        def garbage_collect_all(timestamp)
            query = 'timestamp_s:[* TO \"' + timestamp + '\"]'
            Rails.logger.info("Deleting Solr documents older than #{timestamp}")
            response = @solr.delete_by_query(query)
        end

        # Delete Solr documents for a finding aid that are older than a given timestamp
        def garbage_collect_finding_aid(ead_id, timestamp)
            q1 = 'ead_id_s:\"' + CGI.escape(ead_id) + '\"'
            q2 = 'timestamp_s:[* TO \"' + timestamp + '\"]'
            query = q1 + " AND " + q2
            Rails.logger.info("Deleting Solr documents for EAD ID #{ead_id} older than #{timestamp}")
            response = @solr.delete_by_query(query)
        end

        def most_recent_timestamp_in_solr()
            params = SolrLite::SearchParams.new()
            params.q = 'inventory_level_s:"Finding Aid"'
            params.fl = ["timestamp_s"]
            params.sort = "timestamp_s desc"
            params.page_size = 1
            response = @solr.search(params)
            if response.solr_docs.count > 0
                return Time.parse(response.solr_docs[0]["timestamp_s"])
            end
            nil
        end

        def import_one_file(file_name)
            timestamp = Time.now.to_datetime.to_s
            xml = File.read(file_name)
            ead = Ead.new(xml)
            solr_docs = ead.to_solr(true)
            ead_id = solr_docs[0][:id]

            # Import all the Solr documents generated for this finding aid
            json_docs = solr_docs.map { |solr_doc| solr_doc.to_json }
            json = "[" + json_docs.join(", ") + "]"
            response = @solr.update(json)
            if !response.ok?
                Rails.logger.error("Importing file: #{file_name}. Exception: #{response.error_msg}")
                raise response.error_msg
            end

            # Delete from Solr documents not longer associated with this finding aid
            response = garbage_collect_finding_aid(ead_id, timestamp)
            if !response.ok?
                Rails.logger.error("Deleting previous data for file: #{file_name}, query: #{ead_id}. \r\nException: #{response.error_msg}")
                raise response.error_msg
            end

            nil
        end
end