require "./app/models/ead.rb"

class FullTextImport
    def initialize(pdf_files_path, solr_ead_url, solr_text_url, tika_url)
        @pdf_files_path = pdf_files_path

        @solr_ead = SolrLite::Solr.new(solr_ead_url)
        @solr_ead.def_type = "edismax"

        @solr_text = SolrLite::Solr.new(solr_text_url)
        @solr_text.def_type = "edismax"

        @text_extractor = TextExtractor.new(tika_url)
    end

    # # Adds a Solr document with the text for a file
    # def add_file(doc_hash, text)
    #     # TODO: revisit this
    #     # See https://www.rubyguides.com/2019/05/ruby-ascii-unicode/
    #     text_utf8 = text.encode("UTF-8", "ASCII", invalid: :replace, undef: :replace, replace: "")
    #     doc_hash = {
    #         ead_id_s: ead_id,
    #         filename_s: filename,
    #         text_txt_en: text_utf8
    #     }
    #     json = "[" + doc.to_json + "]"
    #     response = @solr_text.update(json)
    #     if !response.ok?
    #         Rails.logger.error("Adding text to ead_id #{ead_id}: #{filename}. Exception: #{response.error_msg}")
    #         raise response.error_msg
    #     end
    # end

    # Deletes all text documents for a given EAD ID
    def delete_finding_aid(ead_id)
        query = 'ead_id_s:\"' + CGI.escape(ead_id) + '\"'
        response = @solr_text.delete_by_query(query)
        return response.ok?
    end

    # Imports the text of all the files associated with the EAD ID.
    def import_ead_files(ead_id)
        ok = delete_finding_aid(ead_id)
        if !ok
            raise "Error deleting previous information for finding aid #{ead_id}"
        end
        files = get_ead_files(ead_id)
        files.each do |file|
            filename = file["inventory_filename_s"]
            full_filename = "#{@pdf_files_path}/#{ead_id}/#{filename}"
            if !File.exists?(full_filename)
                Rails.logger.info("import_ead_files - file not found (#{full_filename})")
                next
            end

            # Extract the text from the file
            ok, text = @text_extractor.process_file(full_filename)
            if !ok
                Rails.logger.info("import_ead_files - error extracting text (#{full_filename})")
                next
            end
            # TODO: revisit encoding, see https://www.rubyguides.com/2019/05/ruby-ascii-unicode/
            text_utf8 = text.encode("UTF-8", "ASCII", invalid: :replace, undef: :replace, replace: "")

            # Save the text in the Solr text Solr
            doc_hash = file
            doc_hash["text_txt_en"] = text_utf8
            json = "[" + doc_hash.to_json + "]"
            response = @solr_text.update(json)
            if !response.ok?
                Rails.logger.error("Adding text to ead_id #{ead_id}: #{filename}. Exception: #{response.error_msg}")
                raise response.error_msg
            end
        end
    end

    private

        def get_ead_files(ead_id)
            files = []
            params = SolrLite::SearchParams.new()
            params.fl = ["id", "ead_id_s", "inventory_id_s", "inventory_filename_s"]
            params.q = "ead_id_s:\"#{CGI.escape(ead_id)}\" AND inventory_level_s:\"item\""
            params.page_size = 10000 # TODO: implement pagination
            response = @solr_ead.search(params)
            response.solr_docs.each do |doc|
                files << doc
            end
            files
        end

        def elapsed_ms(start)
            ((Time.now - start) * 1000).to_i
        end

        def log_elapsed(start, msg)
            Rails.logger.info("#{msg} took #{elapsed_ms(start)} ms")
        end
end