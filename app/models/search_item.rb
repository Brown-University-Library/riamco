class SearchItem
  attr_accessor :id, :title, :abstract, :extent, :repository

  def initialize(id, title, abstract, extent, repository)
    @id = id
    @title = title
    @abstract = abstract
    @extent = extent
    @repository = repository
  end

  def self.from_hash(h)
    SearchItem.new(h["id"], h["title_s"], h["abstract_txt_en"],
      h["extent_s"], h["repository_name_s"])
  end
end
