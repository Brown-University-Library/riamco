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

    if !is_reading_room?
      Rails.logger.error("Invalid user #{current_user} attempting to view file #{@ead_id} / #{@filename}")
      render "access_denied", status: 401
      return
    end

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
      return EadUtils.valid_id?(id)
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

      # Notice that when loading the template we pass a file reference
      # to Nokogiri rather than the file's content. This allows Nokogiri
      # to resolve referenced files in the XSLT (e.g. <xsl:include href="file2.xsl" />)
      # to the same path as the original file.
      #
      # See https://groups.google.com/d/msg/nokogiri-talk/LZjW70XpkLc/R62XH_dQfpsJ
      template = Nokogiri::XSLT(File.open(xsl_file))

      transformed_doc = template.transform(document)
      html = "<!DOCTYPE html>\r\n" + transformed_doc.to_s
      if is_reading_room?
        # Activate the links to the digital files
        html = html.gsub("digital-file-link-hidden", "digital-file-link-visible")
      end
      html
    end

    def load_pending_ead_html(id, view)
      Rails.logger.info("Generating HTML for pending file #{id}, #{view}")
      xml_file = ENV["EAD_XML_PENDING_FILES_PATH"] + "/#{id}.xml"
      xsl_file = ENV["EAD_XSL_FILES_PATH"] + "/riamco_#{view}.xsl"
      document = Nokogiri::XML(File.read(xml_file))
      template = Nokogiri::XSLT(File.open(xsl_file))  # see note in load_ead_html()
      html = template.transform(document)
    end
end