class EadfileController < ApplicationController
  def show
    id = params["eadid"]
    view = params["view"] || "title"
    file = params["file"]
    Rails.logger.error(file)
    if valid_id?(id) && valid_view?(view)
      html = load_ead_html(id, view, file)
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

    def load_xml(id, pending=false)
      xml = nil
      xml_path = pending ? ENV["EAD_XML_PENDING_FILES_PATH"] : ENV["EAD_XML_FILES_PATH"]
      xml_file = xml_path + "/#{id}.xml"
      if File.exist?(xml_file)
        Rails.logger.info("Reading XML file for #{id}")
        xml = File.read(xml_file)
      else
        Rails.logger.info("No XML file for #{id}")
      end
      xml
    end

    def load_ead_html(id, view, file)
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
          Rails.logger.info(template)

          #Find and replace a specific string in the XSLT to select only one file
          templatetext =  Nokogiri::XSLT(File.read(xsl_file).gsub!('20ProspectStProvidenceRI02912',file))

          Rails.logger.info(templatetext)

          html = templatetext.transform(document)
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

      # Since the admin tool still is posting files to the old location and we are
      # rsync'ing the files to the new location there is a delay between the user
      # uploading a file and the file showing in the new site. For now we
      # display a banner at the top letting the user know the timestamp of the
      # finding aid that they are viewing.
      mtime = File.mtime(xml_file)
      pending_info = '<div id="pending_info" style="background-color:#00ffd2;">Pending finding aid as of: ' + mtime.to_s[0..18] + '</div>'
      html.to_s.gsub('<div id="pending_info"/>', pending_info)
    end

    def download_pdf
    send_file(
      "#{Rails.root}/public/your_file.pdf",
      filename: "your_custom_file_name.pdf",
      type: "application/pdf"
    )
  end
  def pdf
    pdf_filename = File.join(Rails.root, "tmp/my_document.pdf")
    send_file(pdf_filename, :filename => "your_document.pdf", :type => "application/pdf")
  end
end
