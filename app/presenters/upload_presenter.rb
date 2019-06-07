class UploadPresenter < DefaultPresenter
    attr_accessor :files

    def initialize()
        super
    end

    def configure(pending_path, files)
        @pending_path = pending_path
        @files = files.map { |f| File.basename(f, ".xml") }
    end
  end
