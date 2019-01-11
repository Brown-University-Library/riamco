class SearchItem
  attr_accessor :id, :ead_id, :title, :abstract, :extent, :repository,
    :institution_name, :institution_id,
    :inv_level, :inv_label, :inv_date, :inv_container,
    :highlights

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
    @inv_label = inv_label || ""
    @inv_date = inv_date
    @inv_container = inv_container
  end

  def self.from_hash(h, highlights)
    SearchItem.new(h["id"], h["ead_id_s"], h["title_s"], h["abstract_txt_en"],
      h["extent_s"], h["repository_name_s"],
      h["institution_s"], h["institution_id_s"],
      h["inventory_level_s"], h["inventory_label_txt_en"],
      h["inventory_date_s"], h["inventory_container_txt_en"],
      highlights)
  end
end
