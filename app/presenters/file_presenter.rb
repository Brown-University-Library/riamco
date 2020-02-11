class FilePresenter < DefaultPresenter
    attr_accessor :ead_id, :ead_title
    attr_accessor :file_name, :file_label, :file_description, :inv_id

    def configure(file_info)
        @ead_id = file_info[:ead_id]
        @ead_title = file_info[:ead_title]
        @file_name = file_info[:name]           # 123456.pdf
        @file_label = file_info[:label]         # letter to editor.pages
        @file_description = file_info[:description]
        @inv_id = file_info[:inv_id]
    end
  end