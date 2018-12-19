class SearchItem
  attr_accessor :id, :title

  def initialize(id, title)
    @id = id
    @title = title
  end

  def self.from_hash(hash)
    SearchItem.new(hash["id"], hash["title_s"])
  end
end
