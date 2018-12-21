class SearchItem
  attr_accessor :id, :title, :abstract, :extent, :repository, :highlights

  def initialize(id, title, abstract, extent, repository, highlights)
    @id = id
    @title = title
    @abstract = abstract
    @extent = extent
    @repository = repository
    @highlights = highlights
  end

  def self.from_hash(h, highlights)
    SearchItem.new(h["id"], h["title_s"], h["abstract_txt_en"],
      h["extent_s"], h["repository_name_s"], highlights)
  end
end
