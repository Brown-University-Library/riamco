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
        overwrite = (params["overwrite"] == "on")

        error_msg = upload_file(file, overwrite)
        if error_msg != nil
            flash[:alert] = error_msg
            redirect_to upload_form_url()
            return
        end

        Rails.logger.info("Finding aid uploaded: #{file.original_filename}")
        redirect_to upload_list_url()
    end

    # Moves a file from "pending" to "published"
    #
    # The filename to move is selected by the user from a list (not manually entered) so
    # there is very little chance that the filename will be wrong or invalid. Therefore
    # we display pretty short and crude error messages.
    def publish
        eadid = (params["eadid"] || "").strip
        if eadid == ""
            Rails.logger.error("Cannot publish EAD. No ID was provided.")
            flash[:alert] = "No EAD ID was provided."
            redirect_to upload_list_url()
            return
        end

        source = ENV["EAD_XML_PENDING_FILES_PATH"] + "/" + eadid + ".xml"
        target = ENV["EAD_XML_FILES_PATH"] + "/" + eadid + ".xml"
        if !File.exist?(source)
            Rails.logger.error("Cannot publish EAD. Source file not found: #{source}")
            flash[:alert] = "Source file not found for finding aid: #{eadid}."
            redirect_to upload_list_url()
            return
        end

        FileUtils.mv(source, target)
        if !File.exist?(target)
            Rails.logger.error("Cannot publish EAD. File move failed: #{source} => #{target}")
            flash[:alert] = "Could not publish finding aid #{eadid}."
            redirect_to upload_list_url()
            return
        end

        # Touch the file so that it's automatically reindexed into Solr next time the cronjob runs.
        FileUtils.touch(target)

        Rails.logger.info("Published EAD #{eadid}")
        redirect_to ead_show_url(eadid: eadid)
    end

    # Deletes a pending finding aid from disk
    def delete
        eadid = (params["eadid"] || "").strip
        if eadid == ""
            Rails.logger.error("Cannot delete EAD. No ID was provided.")
            flash[:alert] = "No EAD ID was provided."
            redirect_to upload_list_url()
            return
        end

        filename = ENV["EAD_XML_PENDING_FILES_PATH"] + "/" + eadid + ".xml"
        if !File.exist?(filename)
            Rails.logger.error("Cannot delete EAD. File was not found: #{filename}")
            flash[:alert] = "Source file not found for finding aid: #{eadid}."
            redirect_to upload_list_url()
            return
        end

        File.delete(filename)
        if File.exist?(filename)
            Rails.logger.error("Cannot delete EAD. File delete failed: #{filename}")
            flash[:alert] = "Could not delete finding aid #{eadid}."
            redirect_to upload_list_url()
            return
        end

        Rails.logger.info("Findind aid #{eadid} has been deleted")
        flash[:notice] = "Findind aid #{eadid} has been deleted"

        redirect_to upload_list_url()
    end

    private

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
            begin
                xml_content = File.read(filename)
                xml_doc = Nokogiri::XML(xml_content)
                if xml_doc.errors.count > 0
                   raise "Error in XML content."
                end
            rescue => ex
                error_msg = "File uploaded was not a valid XML: #{filename}. "
                if xml_doc != nil && xml_doc.errors.count > 0
                    error_msg += "Errors: #{xml_doc.errors.join('\r\n')}. "
                end
                error_msg += "Exception: #{ex}."
                log_error(error_msg)
                return "File uploaded is not a valid XML file."
            end

            return nil
        end

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

        def require_login
            if current_user == nil
                flash[:alert] = "You must login first."
                redirect_to login_form_url()
            end
        end

        # A filename is valid if:
        #   1. includes only alphanumeric characters (plus _ -.)
        #   2. ends with .xml
        #   3. starts with the indicated prefix.
        def valid_filename(filename, prefix)
            match = filename.match(/[\w.\- ]+\.xml/)
            if match == nil || match.to_s != filename
                return false
            end

            if !filename.start_with?(prefix + "-")
                return false
            end
            true
        end
end