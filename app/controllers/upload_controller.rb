require 'fileutils'
class UploadController < ApplicationController
    # TODO: handle authentication
    # TODO: Validate finding aid parameter to make sure it does not have special chars
    skip_before_filter :verify_authenticity_token

    # Shows list of pending finding aids for this user
    def list
        # TODO: Filter the list of files for the user.
        pending_path = ENV["EAD_XML_PENDING_FILES_PATH"] + "/*.xml"

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
        @presenter.configure(pending_path, file_list)
        render
    end

    # Shows upload form to the user
    def form
        render
    end

    # Uploads a file to the "pending" area.
    def file
        xml_path = ENV["EAD_XML_PENDING_FILES_PATH"]
        file = params["file"]
        overwrite = (params["overwrite"] == "on")
        if !file.is_a?(ActionDispatch::Http::UploadedFile)
            Rails.logger.error("No file to upload was provided.")
            flash[:alert] = "No file to upload was provided."
            redirect_to upload_form_url()
            return
        end

        filename = xml_path + "/" + file.original_filename
        if File.exist?(filename) && !overwrite
            Rails.logger.error("File #{file.original_filename} already exists.")
            flash[:alert] = "File #{file.original_filename} already exists."
            redirect_to upload_form_url()
            return
        end

        if File.extname(filename) != ".xml"
            Rails.logger.error("File #{file.original_filename} has an invalid extension.")
            flash[:alert] = "File #{file.original_filename} has an invalid extension. Must be .xml"
            redirect_to upload_form_url()
            return
        end

        # TODO: Implement validations
        #       a) file size > 0 and <= MAX_FILE_BYTES (20971520)
        #       b) content is XML (perhaps via Nokogiri)
        #
        # See: https://bitbucket.org/bul/riamco/src/956f85073a9c6c5ccff3125c1545ddf7216a2bcf/riamco_admin/views.py#lines-165

        File.open(filename, "wb")  do |f|
            f.write(file.read)
        end
        Rails.logger.info("Finding aid uploaded: #{file.original_filename}")
        eadid = File.basename(filename, ".*")   # drop the extension
        redirect_to upload_list_url()
    end

    # Moves a file from "pending" to "published"
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
end