require "./app/models/ead.rb"

class FullTextImport
    def initialize(pdf_files_path, solr_url, tika_url)
        @pdf_files_path = pdf_files_path

        @solr = SolrLite::Solr.new(solr_url)
        @solr.def_type = "edismax"

        @text_extractor = TextExtractor.new(tika_url)
    end

    # Imports the text of all the files associated with the EAD ID.
    def import_ead_files(ead_id)
        start = Time.now

        # Get the list of files to process from the inventory in the EAD
        files = get_ead_files(ead_id)

        # Process each file
        files.each do |file|
            filename = file["inventory_filename_s"]
            full_filename = "#{@pdf_files_path}/#{ead_id}/#{filename}"
            if !File.exists?(full_filename)
                Rails.logger.info("import_ead_files - file not found (#{full_filename})")
                next
            end

            # Extract the text from the file
            ok, text_ascii = @text_extractor.process_file(full_filename)
            if !ok
                Rails.logger.info("import_ead_files - error extracting text (#{full_filename})")
                next
            end

            # See https://stackoverflow.com/a/17026362/446681
            # and https://www.rubyguides.com/2019/05/ruby-ascii-unicode/
            text_utf8 = text_ascii.force_encoding("utf-8")

            # Save the text in the Sold document. Notice that we are
            # updating parts of the document only.
            # See https://lucene.apache.org/solr/guide/7_5/updating-parts-of-documents.html
            #
            # TODO: Should I also update the timestamp_s value to reflect
            # the date the text was indexed. I need to be careful that this
            # will not result in an endless import loop (EAD => PDF => EAD => PDF ...)
            doc_hash = {
                "id" => file["id"],
                "text_txt_en" => {"set" => text_utf8}
            }
            json = "[" + doc_hash.to_json + "]"
            response = @solr.update(json)
            if !response.ok?
                Rails.logger.error("Adding text to ead_id #{ead_id}: #{filename}. Exception: #{response.error_msg}")
                raise response.error_msg
            end
        end

        StringUtils.log_elapsed(start, "import_ead_files - processed #{files.count} files,")
    end

    private
        def get_ead_files(ead_id)
            files = []
            params = SolrLite::SearchParams.new()
            params.fl = ["id", "ead_id_s", "inventory_id_s", "inventory_filename_s"]
            params.q = "ead_id_s:\"#{CGI.escape(ead_id)}\" AND inventory_level_s:\"item\""
            params.page_size = 10000
            response = @solr.search(params)
            response.solr_docs.each do |doc|
                files << doc
            end
            files
        end
end