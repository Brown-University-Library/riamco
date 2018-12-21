class Search
  def initialize(solr_url)
    logger = ENV["SOLR_VERBOSE"] == "true" ? Rails.logger : nil
    @solr = SolrLite::Solr.new(solr_url, logger)
    @solr.def_type = "edismax"
  end

  def search(params, debug = false)
    extra_fqs = []
    params.fl = nil # ["id", "title_s", "institution_s", "unit_id_s", "abstract_txt_en"]

    # Query filter with custom boost values
    # "short_id_s^2500 email_s^2500 nameText^2000"
    qf = "id abstract_txt_en"

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
        item = SearchItem.from_hash(doc)
        results.items << item
    end
    results
  end
end
