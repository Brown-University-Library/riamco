require 'fileutils'
class UploadController < ApplicationController
    # TODO: handle authentication
    skip_before_filter :verify_authenticity_token

    def list
        pending_path = ENV["EAD_XML_PENDING_FILES_PATH"] + "/*.xml"
        @presenter = UploadPresenter.new()
        @presenter.configure(pending_path, Dir[pending_path])
        render
    end

    def form
        render
    end

    def file
        xml_path = ENV["EAD_XML_FILES_PATH"]
        file = params["file"]
        filename = xml_path + "/" + file.original_filename
        File.open(filename, "wb")  do |f|
            f.write(file.read)
        end
        # TODO: index the file
        render text: "<html><body>file upload</body></html>"
    end

    def publish
        eadid = params["eadid"]
        source = ENV["EAD_XML_PENDING_FILES_PATH"] + "/" + eadid + ".xml"
        target = ENV["EAD_XML_FILES_PATH"] + "/" + eadid + ".xml"
        flash[:notice] = "done done with #{eadid}"
        redirect_to upload_list_url
        # if !File.exist?(source)
        #     render text: "<html><body>source file does not exist</body></html>"
        # else
        #     FileUtils.mv(source, target)
        #     if !File.exist?(target)
        #         render text: "<html><body>error publishing</body></html>"
        #     else
        #         flash[:notice] = "done done with #{eadid}"
        #         render list
        #         # redirect_to ead_show_url(eadid: eadid)
        #     end
        # end
    end
end