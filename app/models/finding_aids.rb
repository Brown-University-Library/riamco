class FindingAids
    def self.all
        Rails.cache.fetch("finding_aids_all", expires_in: 30.day) do
            self.load_from_solr()
        end
    rescue Exception => e
        Rails.logger.error "Finding Aids could not be fetch: #{e.message}"
        {}
    end

    def self.reload_cache()
        Rails.cache.delete("finding_aids_all")
        Rails.cache.write("finding_aids_all", self.load_from_solr())
    end

    def self.load_from_solr()
        start = Time.now
        solr_url = logger = ENV["SOLR_URL"]
        logger = ENV["SOLR_VERBOSE"] == "true" ? Rails.logger : nil
        solr = SolrLite::Solr.new(solr_url, logger)
        solr.def_type = "edismax"
        params = SolrLite::SearchParams.new()
        params.q = 'inventory_level_s:"Finding Aid"'
        params.page_size = 10000 ## TODO: make this value configurable
        results = solr.search(params)
        docs = {}
        results.solr_docs.each do |doc|
            key = doc["id"]
            # TODO: convert these docs to Finding Aid objects.
            docs[key] = doc
        end
        elapsed_ms = ((Time.now - start) * 1000).to_i
        Rails.logger.info "Finding Aids reloaded from Solr (#{elapsed_ms} ms)"
        docs
    end

    def self.count
        self.all.keys.count
    end

    def self.by_id(id)
        self.all[id]
    end
end