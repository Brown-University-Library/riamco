require "./app/models/ead_import.rb"

namespace :riamco do
  desc "Imports to Solr all EAD files in the path given"
  task :import_eads, [:files_path] => :environment do |cmd, args|
    files_path = args[:files_path]
    if files_path == nil
      abort "Must provide file path to import (e.g. /some/path/*.xml)"
    end

    solr_url = ENV["SOLR_URL"]
    if solr_url == nil
        abort "No SOLR_URL defined in the environment"
    end

    importer = EadImport.new(files_path, solr_url)
    errors = importer.import_files()
    errors.each do |err|
        puts err
    end
  end


  desc "Imports to Solr only EAD files that have changed"
  task :update_eads, [:files_path] => :environment do |cmd, args|
    files_path = args[:files_path]
    if files_path == nil
      abort "Must provide file path to import (e.g. /some/path/*.xml)"
    end

    solr_url = ENV["SOLR_URL"]
    if solr_url == nil
        abort "No SOLR_URL defined in the environment"
    end

    importer = EadImport.new(files_path, solr_url)
    errors = importer.import_updated()
    errors.each do |err|
        puts err
    end
  end


  desc "Parses EAD files and outputs to the console the generated JSON that would be used in Solr (but does not import it)"
  task :parse_eads, [:files_path, :import] => :environment do |cmd, args|
    files_path = args[:files_path]
    if files_path == nil
      abort "Must provide file path to import (e.g. /some/path/*.xml)"
    end

    importer = EadImport.new(files_path, "")
    errors = importer.parse_files()
    errors.each do |err|
        puts err
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
