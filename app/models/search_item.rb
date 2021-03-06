class SearchItem
  attr_accessor :id, :ead_id, :date_display,
    :title, :title_filing, :title_sort,
    :abstract, :call_no, :scope_content, :extent, :repository,
    :institution_name, :institution_id,
    :start_year, :end_year,
    :inv_id, :inv_level, :inv_scope_content, :inv_label, :inv_date, :inv_container,
    :timestamp, :highlights, :children, :match_count,
    :file_text, :inv_filename, :inv_filedesc, :sequence

  def initialize(id, ead_id, title, title_filing, title_sort,
    abstract, call_no, scope_content,
    extent, repository, institution_name, institution_id,
    start_year, end_year,
    inv_id, inv_level, inv_scope_content, inv_label, inv_date, inv_container,
    timestamp, highlights)
    @id = id
    @call_no = call_no
    @ead_id = ead_id
    @institution_name = institution_name
    @institution_id = institution_id
    @title = title || ""
    @title_filing = title_filing || ""
    @title_sort = title_sort || ""
    @abstract = abstract || ""
    @scope_content = nil
    if scope_content != nil
      @scope_content = scope_content.join(" ")
    end
    @extent = extent
    @repository = repository
    @start_year = start_year
    @end_year = end_year
    @inv_id = inv_id
    @inv_level = (inv_level || "").capitalize
    @inv_scope_content = inv_scope_content
    @inv_label = inv_label
    @inv_date = inv_date

    # Strip the barcode [in brackets]
    @inv_container = (inv_container || "").gsub(/\[.*\]/,"")

    @timestamp = timestamp
    @highlights = highlights
    @children = []
    @childre_sorted = nil
    @match_count = 0
    @date_display = nil
    @file_text = nil
    @inv_filename = nil
    @inv_filedesc = nil
    @sequence = ""
  end

  def title_hl
    hl_value("title_txt_en", @title)
  end

  def abstract_hl
    hl_value("abstract_txt_en", @abstract)
  end

  def inv_label_hl
    hl_value("inventory_label_txt_en", @inv_label) || ""
  end

  def biog_hist_hl
    hits = @highlights["biog_hist_txt_en"]
    if hits == nil
      return ""
    end
    "..." + hits.join(" ... ") + "..."
  end

  def biog_hist_hl?
    @highlights["biog_hist_txt_en"] != nil
  end

  def scope_content_hl
    hits = @highlights["scope_content_txts_en"]
    if hits == nil
      return ""
    end
    "..." + hits.join(" ... ") + "..."
  end

  def scope_content_hl?
    @highlights["scope_content_txts_en"] != nil
  end

  def subjects_hl
    hits = @highlights["subjects_txts_en"]
    if hits == nil
      return ""
    end
    "..." + hits.join(" ... ") + "..."
  end

  def subjects_hl?
    @highlights["subjects_txts_en"] != nil
  end

  def inv_scope_content_hl
    hl_value("inventory_scope_content_txt_en", @inv_scope_content) || ""
  end

  def file_text_hl?
    @highlights["text_txt_en"] != nil
  end

  def file_text_hl
    if file_text_hl?
      @highlights["text_txt_en"].join("...<br/>")
    else
      @file_text || ""
    end
  end

  def html_id
    # TODO: use a generic regex for this
    return @id.gsub(".", "_")
  end

  def html_inv_id
    # TODO: use a generic regex for this
    return @inv_id.gsub(".", "_")
  end

  def is_file?
    @inv_filename != nil
  end

  def self.from_hash(h, highlights)
    item = SearchItem.new(h["id"], h["ead_id_s"],
      h["title_s"], h["filing_title_s"], h["title_sort_s"],
      h["abstract_txt_en"], h["call_no_s"], h["scope_content_txts_en"],
      h["extent_s"], h["repository_name_s"],
      h["institution_s"], h["institution_id_s"],
      h["start_year_i"], h["end_year_i"],
      h["inventory_id_s"], h["inventory_level_s"], h["inventory_scope_content_txt_en"],
      h["inventory_label_txt_en"], h["inventory_date_s"], h["inventory_container_txt_en"],
      h["timestamp_s"], highlights)

    item.sequence = h["sequence_s"] || ""
    item.date_display = h["date_display_s"]
    item.file_text = (h["text_txt_en"] || "")[0..150]
    item.inv_filename = h["inventory_filename_s"]
    if item.inv_filename != nil
      item.inv_level = "Digital"
    end
    item.inv_filedesc = h["inventory_file_description_txt_en"]
    item
  end

  def add_child(h, highlights)
    @children << SearchItem.from_hash(h, highlights)
  end

  def children_sorted()
    # The sequential field includes the position within the inventory
    # e.g. "US-RPB-ms2018.010-0000636"
    @children_sorted ||= begin
      @children.sort_by {|x| x.sequence }
    end
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
