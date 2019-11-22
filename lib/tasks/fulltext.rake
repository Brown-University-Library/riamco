require "./app/models/text_extractor.rb"

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

  # desc "Extracts text from the files in the filemask, and indexes them into Solr associating them with the EAD ID"
  # task :ft_index_files, [:ead_id, :file_mask] => :environment do |cmd, args|
  #   ead_id = args[:ead_id]
  #   file_mask = args[:file_mask]
  #   Dir.glob(file_mask).each do |filename|
  #     puts "Processing #{filename}"
  #     extractor = TextExtractor.new(ENV["TIKA_URL"])
  #     ok, text = extractor.process_file(filename)
  #     if ok
  #       import = EadImport.new(nil, ENV["SOLR_TEXT_URL"])
  #       import.add_file(ead_id, File.basename(filename), text)
  #       puts "Text of file #{filename} added to EAD #{ead_id}"
  #     else
  #       puts "ERROR: #{text}"
  #     end

  #   end
  # end

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