require 'uri'

class Search
  def initialize(solr_url)
    logger = ENV["SOLR_VERBOSE"] == "true" ? Rails.logger : nil
    @solr = SolrLite::Solr.new(solr_url, logger)
    @solr.def_type = "edismax"
  end

  def search(params, user, debug)
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

    # TODO: Remove hardcoded logic
    rr = (user != nil) && user.is_reading_room?
    is_bornstein = params.fq.count == 1 && params.fq[0].field == "title_s" && params.fq[0].value == "Kate Bornstein papers"
    include_files = rr && is_bornstein && ENV["SOLR_TEXT_URL"]
    limit_to = include_files ? 20 : 4

    # Search within the finding aids indexed in Solr
    results = search_grouped(params, extra_fqs, qf, mm, debug, limit_to)

    if include_files
      # Repeat the search but now within the PDF files indexed for the finding aid
      # TODO: Remove hardcoded logic
      ead_id = "US-RPB-ms2018.010"
      file_items = search_files(ead_id, params.q)

      # If we didn't pick up the finding aid info in the finding aids search
      # and we got results in the files search, load the finding aid info
      if results.items.count == 0 && file_items.count > 0
        finging_aid_doc = FindingAids.by_id(ead_id)
        if finging_aid_doc == nil
          raise("Error getting finding aid with id: #{group_id}")
        end
        results.items << SearchItem.from_hash(finging_aid_doc, {})
      end

      if results.items.count > 0
        # Add the items found in the PDF files as children of the finding aid
        # (notice that we assume a single finding aid is on the list)
        results.items[0].children += file_items
      end
    end

    results
  end

  private
    # Runs a search on the text of the files (which is a separate Solr core)
    # Notice that the results of this search are flat, not grouped.
    def search_files(ead_id, q)
      logger = ENV["SOLR_VERBOSE"] == "true" ? Rails.logger : nil
      solr_url = ENV["SOLR_TEXT_URL"]
      solr = SolrLite::Solr.new(solr_url, logger)
      solr.def_type = "edismax"

      extra_fqs = []
      extra_fqs << SolrLite::FilterQuery.new("ead_id_s", [ead_id])
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

      # Map the result that we got to SearchItems so that we can
      # blend them with the rest of the results.
      items = []
      results.solr_docs.each do |doc|
        id = doc["id"]
        filename = doc["filename_s"]

        # TODO: Instead of using the inventory_id_s from SOLR_TEXT_URL
        # we should find the item in SOLR_URL (by filename) and use
        # that inventory_id_s. This will prevent misalignment if the
        # inventory changes in the EAD.
        #
        # This would also allow us to display the original name of the
        # file (my_bio.pages) rather than the normalized name of
        # the PDF (78981.pdf)
        doc2 = {
          "id" => id,
          "inventory_id_s" => doc["inventory_id_s"],
          "ead_id_s" => doc["ead_id_s"],
          "inventory_container_txt_en" => doc["inventory_filename_s"],
          "inventory_level_s" => "Digital"
        }

        highlights = results.highlights.for(id) || []
        highlights2 = {"text_txt_en" => highlights["text_txt_en"]}

        item = SearchItem.from_hash(doc2, highlights2)
        item.file_text = doc["text_txt_en"]
        items << item
      end
      items
    end

    def search_grouped(params, extra_fqs, qf, mm, debug, limit_to = 4)
      results = @solr.search_group(params, extra_fqs, qf, mm, debug, "ead_id_s", limit_to)
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
