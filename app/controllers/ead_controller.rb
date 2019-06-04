class EadController < ApplicationController
  def show
    id = params["eadid"]
    view = params["view"] || "title"
    if valid_id?(id) && valid_view?(view)
      html = load_ead_html(id, view)
      if html == nil
        render "not_found", status: 404
      else
        render text: html
      end
    else
      Rails.logger.error("Invalid id (#{id}) or view (#{view}) in ead#show")
      render "not_found", status: 404
    end
  rescue => ex
    backtrace = ex.backtrace.join("\r\n")
    Rails.logger.error("Could not render finding aid #{id}, view #{view}. Exception: #{ex} \r\n #{backtrace}")
    render "error", status: 500
  end

  # Pending EADs are on their own folder and available if the user has the
  # ID for it. They are not indexed in Solr, though.
  def show_pending
    id = params["eadid"]
    view = params["view"] || "title"
    if valid_id?(id) && valid_view?(view)
      html = load_pending_ead_html(id, view)
      render text: html
    else
      Rails.logger.error("Invalid id (#{id}) or view (#{view}) in ead#show")
      render "not_found", status: 404
    end
  rescue => ex
    backtrace = ex.backtrace.join("\r\n")
    Rails.logger.error("Could not render pending finding aid #{id}, view #{view}. Exception: #{ex} \r\n #{backtrace}")
    render "error", status: 500
  end

  def download
    id = params["eadid"]
    if valid_id?(id)
      xml = load_xml(id)
      if xml == nil
        render text: "Not found", status: 404
      else
        render xml: xml
      end
    else
      Rails.logger.error("Invalid id (#{id}) in ead#download")
      render "not_found", status: 404
    end
  rescue => ex
    backtrace = ex.backtrace.join("\r\n")
    Rails.logger.error("Could not download finding aid #{id}. Exception: #{ex} \r\n #{backtrace}")
    render "error", status: 500
  end

  private
    # Only accept alphanumeric characters, dashes, underscore or periods.
    def valid_id?(id)
      return false if (id || "").length == 0
      match = /[[:alnum:]\-\_\.]*/.match(id)
      # If the resulting match is identical to the received id it means
      # the id includes only valid characters.
      return match[0] == id
    end

    def valid_view?(view)
      # TODO: restrict to known view names
      valid_id?(view)
    end

    def load_xml(id)
      xml = nil
      xml_file = ENV["EAD_XML_FILES_PATH"] + "/#{id}.xml"
      if File.exist?(xml_file)
        Rails.logger.info("Reading XML file for #{id}")
        xml = File.read(xml_file)
      else
        Rails.logger.info("No XML file for #{id}")
      end
      xml
    end

    def load_ead_html(id, view)
      html = nil
      html_path = ENV["EAD_HTML_FILES_PATH"]
      html_file = html_path + "/#{id}_riamco_#{view}.html"
      if File.exist?(html_file)
        Rails.logger.info("Reading HTML file for #{id}, #{view}")
        html = File.read(html_file)
      else
        xml_file = ENV["EAD_XML_FILES_PATH"] + "/#{id}.xml"
        xsl_file = ENV["EAD_XSL_FILES_PATH"] + "/riamco_#{view}.xsl"
        if !File.exist?(xml_file)
          Rails.logger.info("XML file not found: #{xml_file}")
        elsif !File.exist?(xsl_file)
          Rails.logger.info("XSLT file not found: #{xsl_file}")
        else
          Rails.logger.info("Creating HTML file for #{id}, #{view}")
          document = Nokogiri::XML(File.read(xml_file))
          template = Nokogiri::XSLT(File.read(xsl_file))
          html = template.transform(document)
          # TODO: cache file, maybe?
          # File.write(html_file, html)
        end
      end
      html
    end

    def load_pending_ead_html(id, view)
      Rails.logger.info("Generating HTML for pending file #{id}, #{view}")
      xml_file = ENV["EAD_XML_PENDING_FILES_PATH"] + "/#{id}.xml"
      xsl_file = ENV["EAD_XSL_FILES_PATH"] + "/riamco_#{view}.xsl"
      document = Nokogiri::XML(File.read(xml_file))
      template = Nokogiri::XSLT(File.read(xsl_file))
      html = template.transform(document)
    end
end