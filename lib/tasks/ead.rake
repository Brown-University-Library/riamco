require "./app/models/ead.rb"
require "./app/models/institutions.rb"

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

  desc "Generates the XML used in the original RIAMCO site to import an EAD to Solr"
  task :legacy_to_solr, [:xml_name, :xslt_name] => :environment do |cmd, args|
    xml_file = args[:xml_name]
    xsl_file = args[:xslt_name]
    document = Nokogiri::XML(File.read(xml_file))
    template = Nokogiri::XSLT(File.read(xsl_file))
    xml = template.transform(document)
    puts xml
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
            json = "["
            ead.to_solr(true).each_with_index do |solr_doc, ix|
                if ix > 0
                    json += ", "
                end
                json += solr_doc.to_json
            end
            json += "]"
            # json = "[" + ead.to_solr.to_json + "]"
            solr.update(json)
        rescue => ex
            puts "ERROR on #{file_name}, #{ex}"
        end
    end
end

def process_ead_files(file_path)
    puts "["
    files = Dir[file_path]
    i = 0
    files.each_with_index do |file_name, ix|
        begin
            xml = File.read(file_name)
            ead = Ead.new(xml)
            ead.to_solr(true).each do |solr_doc|
                if i > 0
                    puts ", \r\n"
                end
                i += 1
                puts solr_doc.to_json
            end
            # puts ead.to_solr.to_json
        rescue => ex
            puts "ERROR on #{file_name}, #{ex}, #{ex.backtrace}"
        end
    end
    puts "]"
end