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

  def download_pending
    id = params["eadid"]
    if valid_id?(id)
      xml = load_xml(id, true)
      if xml == nil
        render text: "Not found", status: 404
      else
        render xml: xml
      end
    else
      Rails.logger.error("Invalid id (#{id}) in ead#download_pending")
      render "not_found", status: 404
    end
  rescue => ex
    backtrace = ex.backtrace.join("\r\n")
    Rails.logger.error("Could not download pending finding aid #{id}. Exception: #{ex} \r\n #{backtrace}")
    render "error", status: 500
  end

  def view_file
    @ead_id = params["eadid"]
    @filename = params["filename"]
    if !valid_filename?(@ead_id, @filename)
      Rails.logger.error("Invalid id (#{@ead_id}) or file name (#{@filename}) in ead#view_file")
      render "not_found", status: 404
      return
    end
    render "pdf_view", :layout => false
  rescue => ex
    backtrace = ex.backtrace.join("\r\n")
    Rails.logger.error("Could not render finding aid #{id}, view #{view}. Exception: #{ex} \r\n #{backtrace}")
    render "error", status: 500
  end

  def raw_file
    ead_id = params["eadid"]
    filename = params["filename"]

    if current_user == nil || !current_user.is_reading_room?
      Rails.logger.error("Invalid user #{current_user} attempting to view file #{ead_id} / #{filename}")
      render "error", status: 401
      return
    end

    if !valid_filename?(ead_id, filename)
      Rails.logger.error("Invalid id (#{ead_id}) or file name (#{filename}) in ead#view_file")
      render "not_found", status: 404
      return
    end

    full_filename = full_filename(ead_id, filename)
    send_file(full_filename, filename: filename, disposition: "inline")
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

    def valid_filename?(ead_id, filename)
      if !valid_id?(ead_id) || !valid_id?(filename)
        return false
      end
      fullpath = full_filename(ead_id, filename)
      File.exists?(fullpath)
    end

    def full_filename(ead_id, filename)
      ENV["EAD_DIGITAL_FILES_PATH"] + "/" + ead_id + "/" + filename
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

    def load_ead_html(id, view)
      html_path = ENV["EAD_HTML_FILES_PATH"]
      html_file = html_path + "/#{id}_riamco_#{view}.html"
      xml_file = ENV["EAD_XML_FILES_PATH"] + "/#{id}.xml"
      xsl_file = ENV["EAD_XSL_FILES_PATH"] + "/riamco_#{view}.xsl"
      if !File.exist?(xml_file)
        Rails.logger.info("XML file not found: #{xml_file}")
        return nil
      end
      if !File.exist?(xsl_file)
        Rails.logger.info("XSLT file not found: #{xsl_file}")
        return nil
      end

      Rails.logger.info("Creating HTML for #{id}, #{view}")
      document = Nokogiri::XML(File.read(xml_file))
      template = Nokogiri::XSLT(File.read(xsl_file))
      transformed_doc = template.transform(document)
      html = "<!DOCTYPE html>\r\n" + transformed_doc.to_s
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
end