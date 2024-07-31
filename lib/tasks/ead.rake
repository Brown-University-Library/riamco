require "./app/models/ead_import.rb"

namespace :riamco do
  desc "Reloads the finding aids cache"
  task :reload_cache => :environment do |cmd, args|
    puts "Reloading the finding aids cache..."
    FindingAids.reload_cache()
    puts "Finding aids cache reloaded."
  end

  desc "Deletes an individual EAD from Solr"
  task :delete_ead, [:ead_id] => :environment do |cmd, args|
    ead_id = args[:ead_id]
    if ead_id == nil
      abort "Must provide an EAD ID"
    end

    solr_url = ENV["SOLR_URL"]
    if solr_url == nil
      abort "No SOLR_URL defined in the environment"
    end

    puts "Deleting EAD with ID: #{ead_id} from Solr..."
    importer = EadImport.new(nil, solr_url)
    response = importer.delete_finding_aid(ead_id)
    FindingAids.reload_cache()

    if !response.ok?
      puts "Error deleting EAD from Solr: #{response.error_msg}"
    else
      puts "EAD with ID: #{ead_id} deleted from Solr."
    end
  end

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

    puts "Importing EAD files from path: #{files_path} to Solr..."
    importer = EadImport.new(files_path, solr_url)
    errors = importer.import_files()
    FindingAids.reload_cache()

    if errors.empty?
      puts "All EAD files imported successfully."
    else
      puts "Errors occurred during EAD import:"
      errors.each do |err|
        puts err
      end
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
      puts "Using solr_url: #{solr_url}"
      abort "No SOLR_URL defined in the environment"
    end

    puts "Updating EAD files from path: #{files_path} in Solr..."
    importer = EadImport.new(files_path, solr_url)
    puts "importer: #{importer}"
    result = importer.import_updated()
    puts "result: #{result}"
    result.each do |element|
      puts "element: #{element}"
    end
    if result[:count] > 0
      FindingAids.reload_cache()
      puts "#{result[:count]} EAD files updated in Solr."
    else
      puts "No EAD files updated in Solr."
    end

    if result[:errors].count > 0
      puts "Errors occurred during EAD update:"
      result[:errors].each do |err|
        puts err
      end
    end
  end

  desc "Parses EAD files and outputs to the console the generated JSON that would be used in Solr (but does not import it)"
  task :parse_eads, [:files_path] => :environment do |cmd, args|
    files_path = args[:files_path]
    if files_path == nil
      abort "Must provide file path to import (e.g. /some/path/*.xml)"
    end

    puts "Parsing EAD files from path: #{files_path}..."
    importer = EadImport.new(files_path, "")
    errors = importer.parse_files()
    if errors.empty?
      puts "All EAD files parsed successfully."
    else
      puts "Errors occurred during EAD parsing:"
      errors.each do |err|
        puts err
      end
    end
  end

  desc "Generates the XML used in the original RIAMCO site to import an EAD to Solr"
  task :legacy_to_solr, [:xml_name, :xslt_name] => :environment do |cmd, args|
    xml_file = args[:xml_name]
    xsl_file = args[:xslt_name]
    document = Nokogiri::XML(File.read(xml_file))
    template = Nokogiri::XSLT(File.read(xsl_file))

    puts "Transforming XML using XSLT..."
    xml = template.transform(document)
    puts "XML transformation complete."
    puts xml
  end
end
