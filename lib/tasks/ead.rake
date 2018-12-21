require "./app/models/ead.rb"
require "./app/models/institutions.rb"
require "byebug"

namespace :riamco do
  desc "Generates the JSON to import to Solr the indicated EAD files (and optionally imports it)"
  task :ead_to_solr, [:file_path, :import] => :environment do |cmd, args|
    file_path = args[:file_path]
    if file_path == nil
      abort "Must provide file path to import (e.g. /some/path/*.xml)"
    end

    import = args[:import] == "true"
    if import
        # Generate the JSON for Solr and import it.
        import_ead_files(file_path)
    else
        # Generate the JSON for Solr but don't import it.
        process_ead_files(file_path)
    end
  end
end

def import_ead_files(file_path)
    solr_url = ENV["SOLR_URL"]
    if solr_url == nil 
        abort "No SOLR_URL defined in the environment"
    end
    solr = SolrLite::Solr.new(solr_url)

    files = Dir[file_path]
    files.each_with_index do |file_name, ix|
        begin
            puts "Processing #{file_name}"
            xml = File.read(file_name)
            ead = Ead.new(xml)
            json = "[" + ead.to_solr.to_json + "]"
            solr.update(json)
        rescue => ex 
            puts "ERROR on #{file_name}, #{ex}"
        end
    end
end

def process_ead_files(file_path)
    puts "["
    files = Dir[file_path]
    files.each_with_index do |file_name, ix|
        begin
            if ix > 0 
                puts ", \r\n"
            end
            xml = File.read(file_name)
            ead = Ead.new(xml)
            puts ead.to_solr.to_json
        rescue => ex 
            puts "ERROR on #{file_name}, #{ex}"
        end
    end
    puts "]"
end