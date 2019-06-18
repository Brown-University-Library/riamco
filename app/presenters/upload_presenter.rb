class UploadPresenter < DefaultPresenter
    attr_accessor :file_list

    def configure(pending_path, file_list, user)
        @pending_path = pending_path
        @file_list = file_list
        @user = user
    end
  end
