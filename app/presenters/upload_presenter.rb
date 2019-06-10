class UploadPresenter < DefaultPresenter
    attr_accessor :file_list

    def initialize()
        super
    end

    def configure(pending_path, file_list)
        @pending_path = pending_path
        @file_list = file_list
    end
  end
