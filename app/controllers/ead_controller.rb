class EadController < ApplicationController
  def show
    id = params["id"]
    view = params["view"] || "title"
    html = load_ead_html(id, view)
    render text: html
  end

  def show_legacy
    id = params["eadid"]
    view = params["view"] || "title"
    html = load_ead_html(id, view)
    render text: html
  end

  private
    def load_ead_html(id, view)
      # TODO: clean the id and view parameters
      xml_file = ENV["EAD_XML_FILES_PATH"] + "/#{id}.xml"
      xsl_file = ENV["EAD_XSL_FILES_PATH"] + "/riamco_#{view}.xsl"
      Rails.logger.info(xml_file)
      Rails.logger.info(xsl_file)
      document = Nokogiri::XML(File.read(xml_file))
      template = Nokogiri::XSLT(File.read(xsl_file))
      html = template.transform(document)
      html
    end
end