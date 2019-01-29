require 'uri'

class Search
  def initialize(solr_url)
    logger = ENV["SOLR_VERBOSE"] == "true" ? Rails.logger : nil
    @solr = SolrLite::Solr.new(solr_url, logger)
    @solr.def_type = "edismax"
  end

  def search(params, debug = false, flat_display = false)
    extra_fqs = []
    params.fl = nil

    # The current boost values for title (100) and abstract (.1) are to
    # account for the fact that Solr is weighting the title *too low*
    # and the abstract *too high* by default because of the inverted
    # document frequency (IDF). I think this calculation is because all
    # documents have a title whereas only a few of them (the finding aids)
    # have an abstract which results in Solr considering the abstract
    # hits more unique.
    qf = "id ead_id_s title_txt_en^100 abstract_txt_en^0.1 scope_content_txts_en "
    qf += "inventory_label_txt_en inventory_scope_content_txt_en inventory_path_txt_en "
    qf += "subjects_txts_en"

    params.hl = true
    params.hl_fl = "abstract_txt_en scope_content_txts_en inventory_label_txt_en inventory_scope_content_txt_en"
    params.hl_snippets = 30

    params.spellcheck = true

    # TODO: figure out a good value for this
    mm = nil

    if flat_display
      results = search_flat(params, extra_fqs, qf, mm, debug)
    else
      results = search_grouped(params, extra_fqs, qf, mm, debug)
    end
    results
  end

  private

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
          # TODO: Should we get this via FindingAids.by_id(group_id) instead ?
          solr_id = URI.escape(group_id)
          finging_aid_doc = @solr.get(solr_id)
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

    def search_flat(params, extra_fqs, qf, mm, debug)
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
      results
    end
end
