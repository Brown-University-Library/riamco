class Search
  def initialize(solr_url)
    logger = ENV["SOLR_VERBOSE"] == "true" ? Rails.logger : nil
    @solr = SolrLite::Solr.new(solr_url, logger)
    @solr.def_type = "edismax"
  end

  def search(params, debug = false)
    extra_fqs = []
    params.fl = nil # ["id", "title_s", "institution_s", "unit_id_s", "abstract_txt_en"]
    params.sort = "title_s asc"
    # TODO: decide what fields we should use and their boost values.
    qf = "id abstract_txt_en"

    params.hl = true
    params.hl_fl = "abstract_txt_en"
    params.hl_snippets = 30

    # For information on Solr's Minimum match value see
    #   "Solr in Action" p. 229
    #   and https://lucene.apache.org/solr/guide/6_6/the-dismax-query-parser.html
    #
    # Search terms    Criteria
    # ------------    ------------
    # 1,2             all search terms must be found
    # 3+              at least 75% of the terms must be found
    #                 (this helps with stop words, eg. "professor of history")
    mm = "2<75%"

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
        end
      end
    end

    results
  end
end
