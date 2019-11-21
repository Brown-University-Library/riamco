require 'uri'

class Search
  def initialize(solr_url)
    logger = ENV["SOLR_VERBOSE"] == "true" ? Rails.logger : nil
    @solr = SolrLite::Solr.new(solr_url, logger)
    @solr.def_type = "edismax"
  end

  def search(params, debug = false)
    extra_fqs = []
    params.fl = nil
    mm = nil

    # The current boost values for title (100) and abstract (.1) are to
    # account for the fact that Solr is weighting the title *too low*
    # and the abstract *too high* by default because of the inverted
    # document frequency (IDF). I think this calculation is because all
    # documents have a title whereas only a few of them (the finding aids)
    # have an abstract which results in Solr considering the abstract
    # hits more unique.
    qf = "id ead_id_s title_txt_en^100 abstract_txt_en^0.1 scope_content_txts_en biog_hist_txt_en "
    qf += "inventory_label_txt_en inventory_scope_content_txt_en "
    qf += "subjects_txts_en formats_txts_en keywords_t"

    params.hl = true
    params.hl_fl = "filing_title_s title_txt_en abstract_txt_en scope_content_txts_en subjects_txts_en formats_txts_en biog_hist_txt_en "
    params.hl_fl += "inventory_label_txt_en inventory_scope_content_txt_en"
    params.hl_snippets = 30

    params.spellcheck = true
    results = search_grouped(params, extra_fqs, qf, mm, debug)

    is_bornstein = params.fq.count == 1 && params.fq[0].field == "title_s" && params.fq[0].value == "Kate Bornstein papers"
    include_files = is_bornstein && ENV["SOLR_TEXT_URL"]
    if include_files
      if results.items.count == 0
        solr_id = "US-RPB-ms2018.010" # Kate Bornstein papers
        finging_aid_doc = FindingAids.by_id(solr_id)
        if finging_aid_doc == nil
          raise("Error getting finding aid with id: #{group_id}")
        end
        results.items << SearchItem.from_hash(finging_aid_doc, {})
      end

      # TODO: Merge the results from the files on the proper finding aid
      # TODO: Pass the ead_id as an qf filter to this search
      res_files = search_files(params.q)
      results.items[0].children += res_files.items
    end

    results
  end

  private
    # Runs a search on the text of the files (which is a separate Solr core)
    def search_files(q)
      logger = ENV["SOLR_VERBOSE"] == "true" ? Rails.logger : nil
      solr_url = ENV["SOLR_TEXT_URL"]
      solr = SolrLite::Solr.new(solr_url, logger)
      solr.def_type = "edismax"

      extra_fqs = []
      params = SolrLite::SearchParams.new()
      params.fq = []
      params.fl = nil
      params.q = q
      qf = "text_txt_en"
      params.hl = true
      params.hl_fl = "text_txt_en"
      params.hl_snippets = 30
      params.spellcheck = true
      debug = false
      mm = nil
      results = solr.search(params, extra_fqs, qf, mm, debug)
      if !results.ok?
        raise("Solr reported: #{results.error_msg}")
      end

      results.solr_docs.each do |doc|
        id = doc["id"]
        filename = doc["filename_s"]

        # Map the result that we got from SOLR_TEXT_URL to look as if
        # we got it from SOLR_TEXT so that we can blend it with the rest
        # of the results.
        doc2 = {
          "id" => id,
          "inventory_scope_content_txt_en" => doc["text_txt_en"],
          "inventory_container_txt_en" => filename ||  ""
        }

        highlights = results.highlights.for(id) || []
        highlights2 = {"inventory_scope_content_txt_en" => highlights["text_txt_en"]}

        item = SearchItem.from_hash(doc2, highlights2)
        results.items << item
      end
      results
    end

    def search_grouped(params, extra_fqs, qf, mm, debug)
      results = @solr.search_group(params, extra_fqs, qf, mm, debug, "ead_id_s", 4)
      if !results.ok?
        raise("Solr reported: #{results.error_msg}")
      end

      groups_ids = results.solr_groups("ead_id_s")
      groups_ids.each do |group_id|
        docs_for_group = results.solr_docs_for_group("ead_id_s", group_id)
        # Try to create the item with finding aid information
        # if the finding aid document is found in the resultset.
        item = nil
        docs_for_group.each do |doc|
          if doc["inventory_level_s"] == "Finding Aid"
            highlights = results.highlights.for(doc["id"]) || {}
            item = SearchItem.from_hash(doc, highlights)
            break
          end
        end

        if item == nil
          # The finding aid was not in the result set, fetch it.
          solr_id = URI.escape(group_id)
          finging_aid_doc = FindingAids.by_id(solr_id)
          if finging_aid_doc == nil
            raise("Error getting finding aid with id: #{group_id}")
          end
          item = SearchItem.from_hash(finging_aid_doc, {})
        end

        item.match_count = results.num_found_for_group("ead_id_s", group_id)

        docs_for_group.each do |doc|
          if doc["inventory_level_s"] == "Finding Aid"
            # skip it
          else
            highlights = results.highlights.for(doc["id"]) || {}
            item.add_child(doc, highlights)
          end
        end
        results.items << item
      end
      results
    end
end
