class FilePresenter < DefaultPresenter
    attr_accessor :ead_id, :ead_title, :call_no
    attr_accessor :file_name, :file_label, :file_description, :scope_content, :inv_id

    def configure(file_info)
        @ead_id = file_info[:ead_id]
        @ead_title = file_info[:ead_title]
        @call_no = file_info[:call_no] || @ead_id
        @file_name = file_info[:name]           # 123456.pdf
        @file_label = file_info[:label]         # letter to editor.pages
        @file_description = file_info[:description]
        @scope_content = (file_info[:scope_content] || "")
        @inv_id = file_info[:inv_id]
    end
  end