require 'fileutils'
class UploadController < ApplicationController
    before_action :require_login

    MAX_FILE_BYTES = 20_971_520  # 20MB

    # needed for number_with_delimiter
    include ActionView::Helpers::NumberHelper

    # Shows list of pending finding aids for this user
    def list
        files_mask = "*.xml"
        if current_user.role != "admin"
            files_mask = "#{current_user.fileprefix}-*.xml"
        end
        pending_path = ENV["EAD_XML_PENDING_FILES_PATH"] + "/#{files_mask}"
        Rails.logger.info("Loading pending files at #{pending_path}")

        file_list = []
        Dir[pending_path].each do |file|
            file_info = {
                name: File.basename(file, ".xml"),
                timestamp: File.mtime(file),
                display_date: File.mtime(file).strftime("%Y-%m-%d %I:%M %p")
            }
            file_list << file_info
        end
        file_list.sort_by! {|x| x[:timestamp]}.reverse!

        @presenter = UploadPresenter.new()
        @presenter.configure(pending_path, file_list, current_user)
        render
    rescue => ex
        render_error("list", ex, current_user)
    end

    # Checks if the indicated file exists on the pending area
    def check_exists
        filename = params["file"]
        if !valid_filename(filename, nil)
            Rails.logger.warn("check_exists: Invalid filename received (#{filename})")
            render :json => {error: "Invalid filename"}, status: 400
            return
        end

        full_filename = ENV["EAD_XML_PENDING_FILES_PATH"] + "/" + filename
        exist = File.exist?(full_filename)
        render :json => {exist: exist}
    end

    # Shows upload form to the user
    def form
        @presenter = DefaultPresenter.new()
        @presenter.user = current_user
        render
    end

    # Uploads a file to the "pending" area.
    def file
        file = params["file"]
        overwrite = (params["overwrite"] == "yes")

        error_msg = upload_file(file, overwrite)
        if error_msg != nil
            flash[:alert] = error_msg
            redirect_to upload_form_url()
            return
        end

        Rails.logger.info("Finding aid uploaded: #{file.original_filename}")
        redirect_to upload_list_url()
    rescue => ex
        render_error("file", ex, current_user)
    end

    # Moves a file from "pending" to "published"
    #
    # The filename to move is selected by the user from a list (not manually entered) so
    # there is very little chance that the filename will be wrong or invalid. Therefore
    # we display pretty short and crude error messages.
    def publish
        eadid = (params["eadid"] || "").strip
        if eadid == ""
            log_error("Cannot publish EAD. No ID was provided.")
            flash[:alert] = "No EAD ID was provided."
            redirect_to upload_list_url()
            return
        end

        source = ENV["EAD_XML_PENDING_FILES_PATH"] + "/" + eadid + ".xml"
        target = ENV["EAD_XML_FILES_PATH"] + "/" + eadid + ".xml"
        if !File.exist?(source)
            log_error("Cannot publish EAD. Source file not found: #{source}")
            flash[:alert] = "Source file not found for finding aid: #{eadid}."
            redirect_to upload_list_url()
            return
        end

        FileUtils.mv(source, target)
        if !File.exist?(target)
            log_error("Cannot publish EAD. File move failed: #{source} => #{target}")
            flash[:alert] = "Could not publish finding aid #{eadid}."
            redirect_to upload_list_url()
            return
        end

        # Touch the file so that it's automatically reindexed into Solr next time the cronjob runs.
        FileUtils.touch(target)

        Rails.logger.info("Published EAD #{eadid}")
        flash[:notice] = "Finding aid #{eadid} has been published."
        redirect_to upload_list_url()
    rescue => ex
        render_error("publish", ex, current_user)
    end

    # Deletes a pending finding aid from disk
    def delete
        eadid = (params["eadid"] || "").strip
        if eadid == ""
            log_error("Cannot delete EAD. No ID was provided.")
            flash[:alert] = "No EAD ID was provided."
            redirect_to upload_list_url()
            return
        end

        filename = ENV["EAD_XML_PENDING_FILES_PATH"] + "/" + eadid + ".xml"
        if !File.exist?(filename)
            log_error("Cannot delete EAD. File was not found: #{filename}")
            flash[:alert] = "Source file not found for finding aid: #{eadid}."
            redirect_to upload_list_url()
            return
        end

        target = ENV["EAD_XML_DELETED_FILES_PATH"] + "/" + eadid + ".xml"
        FileUtils.mv(filename, target)

        if !File.exist?(target)
            log_error("File delete failed: #{filename}")
            flash[:alert] = "Could not delete finding aid #{eadid}."
            redirect_to upload_list_url()
            return
        end

        Rails.logger.info("Findind aid #{eadid} has been deleted")
        flash[:notice] = "Findind aid #{eadid} has been deleted"
        redirect_to upload_list_url()
    rescue => ex
        render_error("delete", ex, current_user)
    end

    private
        # Logs the error and username of the current that encountered the error.
        def log_error(error)
            error_msg = error
            if current_user == nil
                error_msg += " User: nil"
            else
                error_msg += " User: #{current_user.username}"
            end
            Rails.logger.error(error_msg)
        end

        def render_error(action, ex, user)
            backtrace = ex.backtrace.join("\r\n")
            Rails.logger.error("Error in UploadController. Action: #{action}. User: #{current_user.username}. Exception: #{ex} \r\n #{backtrace}")
            render "error", status: 500
        end

        def require_login
            if current_user == nil
                flash[:alert] = "You must login first."
                redirect_to login_form_url()
            end
        end

        def upload_file(file, overwrite)
            if !file.is_a?(ActionDispatch::Http::UploadedFile)
                log_error("No file to upload was provided.")
                return "No file to upload was provided."
            end

            # Validate filename
            if !valid_filename(file.original_filename, current_user.fileprefix)
                log_error("Invalid filename provided: #{file.original_filename} (#{current_user.fileprefix})")
                return "Invalid filename provided. Filename must start with #{current_user.fileprefix} and end with .xml"
            end

            # Validate overwrite
            filename = ENV["EAD_XML_PENDING_FILES_PATH"] + "/" + file.original_filename
            if File.exist?(filename) && !overwrite
                log_error("File #{file.original_filename} already exists.")
                return "File #{file.original_filename} already exists."
            end

            # Validate filesize
            size = File.size(file.tempfile)
            if size == 0
                log_error("Attempt to upload zero bytes file: #{file.original_filename}")
                return "File cannot be empty (file size: zero bytes)."
            elsif size > MAX_FILE_BYTES
                log_error("Attempt to upload file greater than 20MB: #{file.original_filename}, #{size} bytes.")
                return "File is too big, file cannot not be greater than #{number_with_delimiter(MAX_FILE_BYTES)} bytes (file size: #{number_with_delimiter(size)} bytes)."
            end

            # Save the file to the "pending" area
            File.open(filename, "wb")  do |f|
                f.write(file.read)
            end

            # Make sure its a valid XML file
            xml_doc = nil
            error_detail = nil
            begin
                xml_content = File.read(filename)
                xml_doc = Nokogiri::XML(xml_content)
                if xml_doc.errors.count > 0
                   raise "Error in XML content."
                end

                ead_id = xml_doc.xpath("xmlns:ead/xmlns:eadheader/xmlns:eadid[1]/text()").text
                base_filename = File.basename(filename,".xml")
                if ead_id != base_filename
                    error_detail = "The filename (#{base_filename}) does not match the metadata in the <eadid> tag (#{ead_id})."
                    raise "Error in XML content."
                end

            rescue => ex
                error_msg = "File uploaded was not a valid XML: #{filename}. "
                if xml_doc != nil && xml_doc.errors.count > 0
                    error_msg += "Errors: #{xml_doc.errors.join('\r\n')}. "
                end
                error_msg += "Exception: #{ex}."
                log_error(error_msg)

                FileUtils.rm([filename], force: true)

                return "File uploaded is not a valid XML file. #{error_detail}"
            end

            return nil
        end

        # A filename is valid if:
        #   1. includes only alphanumeric characters (plus _ -.)
        #   2. ends with .xml
        #   3. starts with the indicated prefix.
        def valid_filename(filename, prefix)
            return false if filename == nil

            match = filename.match(/[\w.\- ]+\.xml/)
            if match == nil || match.to_s != filename
                return false
            end

            if prefix != nil
                if !filename.start_with?(prefix + "-")
                    return false
                end
            end
            true
        end
end