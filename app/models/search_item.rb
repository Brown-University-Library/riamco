class SearchItem
  attr_accessor :id, :ead_id, :title, :abstract, :scope_content,
    :extent, :repository, :institution_name, :institution_id,
    :inv_level, :inv_scope_content, :inv_label, :inv_date, :inv_container,
    :highlights, :children, :match_count

  def initialize(id, ead_id, title, abstract, scope_content,
    extent, repository, institution_name, institution_id,
    inv_level, inv_scope_content, inv_label, inv_date, inv_container, highlights)
    @id = id
    @ead_id = ead_id
    @institution_name = institution_name
    @institution_id = institution_id
    @title = title || ""
    @abstract = abstract || ""
    @scope_content = nil
    if scope_content != nil
      @scope_content = scope_content.join(" ")
    end
    @extent = extent
    @repository = repository
    @highlights = highlights
    @inv_level = inv_level
    @inv_scope_content = inv_scope_content
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

  def scope_content_hl
    # hl_value("scope_content_txts_en", @scope_content) || ""
    hits = @highlights["scope_content_txts_en"]
    if hits == nil
      return value || ""
    end
    "..." + hits.join(" ... ") + "..."
  end

  def scope_content_hl?
    @highlights["scope_content_txts_en"] != nil
  end

  def inv_scope_content_hl
    hl_value("inventory_scope_content_txt_en", @inv_scope_content) || ""
  end

  def self.from_hash(h, highlights)
    SearchItem.new(h["id"], h["ead_id_s"], h["title_s"],
      h["abstract_txt_en"], h["scope_content_txts_en"],
      h["extent_s"], h["repository_name_s"],
      h["institution_s"], h["institution_id_s"],
      h["inventory_level_s"], h["inventory_scope_content_txt_en"], h["inventory_label_txt_en"],
      h["inventory_date_s"], h["inventory_container_txt_en"],
      highlights)
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
