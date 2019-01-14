class SearchItem
  attr_accessor :id, :ead_id, :title, :abstract, :extent, :repository,
    :institution_name, :institution_id,
    :inv_level, :inv_label, :inv_date, :inv_container,
    :highlights, :children, :match_count

  def initialize(id, ead_id, title, abstract, extent, repository, institution_name, institution_id,
    inv_level, inv_label, inv_date, inv_container, highlights)
    @id = id              # Solr id
    @ead_id = ead_id      # EAD id
    @institution_name = institution_name
    @institution_id = institution_id
    @title = title || ""
    @abstract = abstract || ""
    @extent = extent
    @repository = repository
    @highlights = highlights
    @inv_level = inv_level
    @inv_label = inv_label
    @inv_date = inv_date
    @inv_container = inv_container
    @children = []
    @match_count = 0
  end

  def abstract_hl
    hl_value("abstract_txt_en", @abstract)
  end

  def inv_label_hl
    hl_value("inventory_label_txt_en", @inv_label) || ""
  end

  def self.from_hash(h, highlights)
    SearchItem.new(h["id"], h["ead_id_s"], h["title_s"], h["abstract_txt_en"],
      h["extent_s"], h["repository_name_s"],
      h["institution_s"], h["institution_id_s"],
      h["inventory_level_s"], h["inventory_label_txt_en"],
      h["inventory_date_s"], h["inventory_container_txt_en"],
      highlights)
  end

  def self.for_collection(id)
    SearchItem.new(id, id, "title for #{id}", "abstract for #{id}",
      "extent_s for #{id}", "repo for #{id}",
      "inst for #{id}", "inst id for #{id}",
      "Collection",  nil,
      nil, nil,
      {})
  end

  def add_child(h, highlights)
    @children << SearchItem.from_hash(h, highlights)
  end

  private 
    def hl_value(solr_field, value)
      hits = @highlights[solr_field]
      if hits == nil
        return value
      end
      txt = value
      hits.each do |hit|
        plain = hit.gsub("<em>", "").gsub("</em>", "")
        txt.gsub!(plain, hit)
      end
      txt
    end
end
