require "./app/models/ead.rb"

class EadImport
    def initialize(files_path, solr_url)
        @files_path = files_path
        @solr = SolrLite::Solr.new(solr_url)
        @solr.def_type = "edismax"
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
                log_elapsed(start_file, "  File: #{File.basename(file_name)} [#{ix+1}/#{count}]")
            rescue => ex
                log_elapsed(start_file, "  Error on file: #{File.basename(file_name)}. #{ex}")
                errors << "File: #{file_name}. #{ex}, #{ex.backtrace}"
            end
        end
        log_elapsed(start_all, "Import ended")
        return errors
    end

    # Imports to Solr the XML files in the path that have changed since the given timestamp.
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
                    log_elapsed(start_file, "  File: #{File.basename(file_name)}")
                    count += 1
                end
            rescue => ex
                # log_elapsed(start_file, "  Error on file: #{File.basename(file_name)}")
                errors << "File: #{file_name}: #{ex}, #{ex.backtrace}"
            end
        end
        log_elapsed(start_all, "Import ended, #{count} files were imported")
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
            xml = File.read(file_name)
            ead = Ead.new(xml)
            solr_docs = ead.to_solr(true)

            # Delete from Solr all previous information for this finding aid
            ead_id = solr_docs[0][:id]
            query = "ead_id_s:#{ead_id}"
            response = @solr.delete_by_query(query)
            if !response.ok?
                Rails.logger.error("Deleting previous data for file: #{file_name}, query: #{query}. Exception: #{response.error_msg}")
                raise response.error_msg
            end

            # Import all the Solr documents generated for this finding aid
            json_docs = solr_docs.map { |solr_doc| solr_doc.to_json }
            json = "[" + json_docs.join(", ") + "]"
            response = @solr.update(json)
            if !response.ok?
                Rails.logger.error("Importing file: #{file_name}. Exception: #{response.error_msg}")
                raise response.error_msg
            end
            nil
        end

        def elapsed_ms(start)
            ((Time.now - start) * 1000).to_i
        end

        def log_elapsed(start, msg)
            Rails.logger.info("#{msg} took #{elapsed_ms(start)} ms")
        end
end