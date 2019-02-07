class EadController < ApplicationController
  def show
    id = params["eadid"]
    view = params["view"] || "title"
    html = load_ead_html(id, view)
    render text: html
  end

  def download
    id = params["eadid"]
    xml = load_xml(id)
    if xml == nil
      render text: "Not found", status: 404
    else
      render xml: xml
    end
  end

  private
    def load_xml(id)
      # TODO: clean the id
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
      # TODO: clean the id and view parameters
      html = ""
      html_path = ENV["EAD_HTML_FILES_PATH"]
      html_file = html_path + "/#{id}_riamco_#{view}.html"
      if File.exist?(html_file)
        Rails.logger.info("Reading HTML file for #{id}, #{view}")
        html = File.read(html_file)
      else
        Rails.logger.info("Creating HTML file for #{id}, #{view}")
        xml_file = ENV["EAD_XML_FILES_PATH"] + "/#{id}.xml"
        xsl_file = ENV["EAD_XSL_FILES_PATH"] + "/riamco_#{view}.xsl"
        document = Nokogiri::XML(File.read(xml_file))
        template = Nokogiri::XSLT(File.read(xsl_file))
        html = template.transform(document)
        File.write(html_file, html)
      end
      html
    end
end