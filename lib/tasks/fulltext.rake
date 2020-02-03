require "./app/models/text_extractor.rb"

# Pre-requisites:
#   Download the Tika Server from https://www.apache.org/dyn/closer.cgi/tika/tika-server-1.23.jar
#   Start the server via `java -jar tika-server-1.23.jar`
#
namespace :riamco do
  desc "Extracts text from a file via a Tika Server"
  task :ft_extract, [:filename] => :environment do |cmd, args|
    extractor = TextExtractor.new(ENV["TIKA_URL"])
    filename = args[:filename]
    ok, text = extractor.process_file(filename)
    if ok
      puts text
    else
      puts "ERROR: #{text}"
    end
  end

  desc "Index the text of all the files associated with a EAD ID"
  task :ft_index_ead, [:ead_id] => :environment do |cmd, args|
    ead_id = args[:ead_id]
    pdf_files_path = ENV["EAD_DIGITAL_FILES_PATH"]
    solr_ead_url = ENV["SOLR_URL"]
    solr_text_url = ENV["SOLR_TEXT_URL"]
    tika_url = ENV["TIKA_URL"]
    ft_import = FullTextImport.new(pdf_files_path, solr_ead_url, solr_text_url, tika_url)
    ft_import.import_ead_files(ead_id)
    puts "done"
  end

  desc "Deletes all documents from the full text index"
  task :ft_clean_index do |cmd, args|
    solr_url = ENV["SOLR_TEXT_URL"]
    solr = SolrLite::Solr.new(solr_url)
    solr.delete_all!
  end
end