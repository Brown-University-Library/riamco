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

  desc "Extracts text from a file associated with an EAD ID and indexes into Solr"
  task :ft_index, [:ead_id, :filename] => :environment do |cmd, args|
    ead_id = args[:ead_id]
    filename = args[:filename]
    extractor = TextExtractor.new(ENV["TIKA_URL"])
    ok, text = extractor.process_file(filename)
    if ok
      import = EadImport.new(nil, ENV["SOLR_TEXT_URL"])
      import.add_file(ead_id, File.basename(filename), text)
      puts "Text of file #{filename} added to EAD #{ead_id}"
    else
      puts "ERROR: #{text}"
    end
  end
end