class Search
  def initialize(solr_url)
    logger = ENV["SOLR_VERBOSE"] == "true" ? Rails.logger : nil
    @solr = SolrLite::Solr.new(solr_url, logger)
    @solr.def_type = "edismax"
  end

  def search(params, debug = false)
    extra_fqs = []
    params.fl = nil
    # params.sort = "title_s asc"

    # The current boost values for title (100) and abstract (.1) are to
    # account for the fact that Solr is weighting the title *too low*
    # and the abstract *too high* by default because of the inverted
    # document frequency (IDF). I think this calculation is because all
    # documents have a title whereas only a few of them (the collections)
    # have an abstract which results in Solr considering the abstract
    # hits more unique.
    #
    # TODO: decide what fields we should use and their boost values.
    qf = "id ead_id title_txt_en^100 abstract_txt_en^0.1 inventory_label_txt_en inventory_path_txt_en subjects_txts_en"

    params.hl = true
    params.hl_fl = "abstract_txt_en inventory_label_txt_en"
    params.hl_snippets = 30

    # TODO: figure out a good value for this
    mm = nil

    results = @solr.search(params, extra_fqs, qf, mm, debug)
    if !results.ok?
      raise("Solr reported: #{results.error_msg}")
    end

    results.solr_docs.each do |doc|
        id = doc["id"]
        highlights = results.highlights.for(id) || []
        item = SearchItem.from_hash(doc, highlights)
        results.items << item
    end

    results.items.each do |result|
      result.highlights.each do |hl|
        hl_field = hl[0]
        hl_hits = hl[1]
        if hl_field == "abstract_txt_en"
          hl_hits.each do |hit|
            # update the abstract text with the highlighted text
            text = hit.gsub("<em>", "").gsub("</em>", "")
            result.abstract.gsub!(text, hit)
          end
        elsif hl_field == "inventory_label_txt_en"
          hl_hits.each do |hit|
            # update the label text with the highlighted text
            text = hit.gsub("<em>", "").gsub("</em>", "")
            result.inv_label.gsub!(text, hit)
          end
        end
      end
    end

    results
  end
end
