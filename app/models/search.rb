require 'uri'

class Search
  def initialize(solr_url)
    logger = ENV["SOLR_VERBOSE"] == "true" ? Rails.logger : nil
    @solr = SolrLite::Solr.new(solr_url, logger)
    @solr.def_type = "edismax"
  end

  def search(params, rr_request, debug)
    extra_fqs = []
    params.fl = nil
    mm = nil
    limit_to = 4

    # The current boost values for title (100) and abstract (.1) are to
    # account for the fact that Solr is weighting the title *too low*
    # and the abstract *too high* by default because of the inverted
    # document frequency (IDF). I think this calculation is because all
    # documents have a title whereas only a few of them (the finding aids)
    # have an abstract which results in Solr considering the abstract
    # hits more unique.
    qf = "id ead_id_s title_txt_en^100 abstract_txt_en^0.1 scope_content_txts_en biog_hist_txt_en "
    qf += "inventory_label_txt_en inventory_scope_content_txt_en "
    qf += "subjects_txts_en formats_txts_en text_txt_en keywords_t"

    params.hl = true
    params.hl_fl = "filing_title_s title_txt_en abstract_txt_en scope_content_txts_en subjects_txts_en formats_txts_en biog_hist_txt_en "
    params.hl_fl += "inventory_label_txt_en inventory_scope_content_txt_en text_txt_en"
    params.hl_snippets = 4

    params.spellcheck = true

    results = search_grouped(params, extra_fqs, qf, mm, debug, limit_to, rr_request)
    results
  end

  def search_files(ead_id, q, page_size, rr_request)
    fq = SolrLite::FilterQuery.new("ead_id_s", [ead_id])
    params = SolrLite::SearchParams.new()
    params.fq = [fq]
    params.fl = nil
    params.q = q
    params.hl = true
    params.hl_fl = "text_txt_en"
    params.hl_snippets = 4
    params.spellcheck = true
    if page_size != nil
      params.page_size = page_size
    end

    extra_fqs = []
    qf = "text_txt_en"
    mm = nil
    debug = false

    results = @solr.search(params, extra_fqs, qf, mm, debug)
    if !results.ok?
      raise("Solr reported: #{results.error_msg}")
    end

    items = []
    results.solr_docs.each do |doc|
      id = doc["id"]
      highlights = results.highlights.for(id) || []
      if !rr_request
        highlights["text_txt_en"] = nil
        inv_id = doc["inventory_id_s"]
        doc["text_txt_en"] = "Access restricted. " + more_info_link(ead_id, inv_id) + "."
      end

      item = SearchItem.from_hash(doc, highlights)
      items << item
    end
    return items, results.num_found
  end

  # Finds file metadata for a given inventory_filename
  def file_metadata(ead_id, inventory_filename)
    params = SolrLite::SearchParams.new()
    fq = SolrLite::FilterQuery.new("ead_id_s", [ead_id])
    params.fq = [fq]
    params.fl = nil
    params.q = inventory_filename
    extra_fqs = []
    qf = "inventory_filename_s"
    debug = false
    mm = nil
    results = @solr.search(params, extra_fqs, qf, mm, debug)
    if !results.ok?
      raise("Solr reported: #{results.error_msg}")
    end

    if results.solr_docs.count != 1
      search_key = "#{ead_id} / #{inventory_filename}"
      Rails.logger.error("file_metadata: #{results.solr_docs.count} results found for #{search_key}.")
      return nil
    end

    finding_aid_doc = FindingAids.by_id(ead_id)
    if finding_aid_doc == nil
      Rails.logger.error("file_metadata: could not fetch finding aid info (#{ead_id}).")
      return nil
    end

    info = {
        ead_id: finding_aid_doc["ead_id_s"],
        call_no: finding_aid_doc["call_no_s"],
        ead_title: finding_aid_doc["title_txt_en"],
        name: results.solr_docs[0]["inventory_filename_s"],
        label: results.solr_docs[0]["inventory_label_txt_en"],
        description: results.solr_docs[0]["inventory_file_description_txt_en"],
        scope_content: results.solr_docs[0]["inventory_scope_content_txt_en"],
        inv_id: results.solr_docs[0]["inventory_id_s"]
      }
    info
  end

  # Finds file parent ID for a given inventory ID
  def parent_id(ead_id, inv_id)
    if inv_id == nil
      return nil
    end

    log_key = "#{ead_id}, #{inv_id}"
    fq = SolrLite::FilterQuery.new("ead_id_s", [ead_id])
    extra_fqs = []
    debug = false
    mm = nil

    # Find the inventory node requested...
    params = SolrLite::SearchParams.new()
    params.fq = [fq]
    params.q = inv_id
    results = @solr.search(params, extra_fqs, "inventory_id_s", mm, debug)
    if !results.ok?
      raise("Solr reported: #{results.error_msg}")
    end

    if results.solr_docs.count != 1
      Rails.logger.error("parent_id: #{results.solr_docs.count} results found for #{log_key}.")
      return nil
    end

    # ...get the parent path for this inventory node...
    path = results.solr_docs[0]["inventory_descendent_path"] || ""
    tokens = path.split("/")
    if tokens.count < 2
      Rails.logger.error("parent_id: cannot determine parent path for #{log_key}.")
      return nil
    end
    parent_path = tokens[0..(tokens.count-2)].join("/")

    # ...find the parent node
    params = SolrLite::SearchParams.new()
    params.fq = [fq]
    params.q = parent_path
    results = @solr.search(params, extra_fqs, "inventory_descendent_path", mm, debug)
    if !results.ok?
      raise("Solr reported: #{results.error_msg}")
    end

    if results.solr_docs.count != 1
      Rails.logger.error("parent_id: #{results.solr_docs.count} parent results found for #{log_key}.")
      return nil
    end

    results.solr_docs[0]["inventory_id_s"]
  end

  private
    # Issues the search and groups the results.
    def search_grouped(params, extra_fqs, qf, mm, debug, limit_to = 4, rr_request = false)
      results = @solr.search_group(params, extra_fqs, qf, mm, debug, "ead_id_s", limit_to)
      if !results.ok?
        raise("Solr reported: #{results.error_msg}")
      end

      groups_ids = results.solr_groups("ead_id_s")
      groups_ids.each do |group_id|
        docs_for_group = results.solr_docs_for_group("ead_id_s", group_id)

        # Try to get the finding aid information from the
        # documents for this group.
        finding_aid = nil
        docs_for_group.each do |doc|
          if doc["inventory_level_s"] == "Finding Aid"
            highlights = results.highlights.for(doc["id"]) || {}
            finding_aid = SearchItem.from_hash(doc, highlights)
            break
          end
        end

        if finding_aid == nil
          # The finding aid was not in the documents for this group,
          # fetch the finding aid directly from our cache.
          solr_id = URI.escape(group_id)
          finging_aid_doc = FindingAids.by_id(solr_id)
          if finging_aid_doc == nil
            raise("Error getting finding aid with id: #{group_id}")
          end
          finding_aid = SearchItem.from_hash(finging_aid_doc, {})
        end

        finding_aid.match_count = results.num_found_for_group("ead_id_s", group_id)

        # Append each document in the group as a children to the finding aid
        docs_for_group.each do |doc|
          if doc["inventory_level_s"] == "Finding Aid"
            # skip it -- we already handled the finding aid
            next
          end
          highlights = results.highlights.for(doc["id"]) || {}
          if !rr_request
            highlights["text_txt_en"] = nil
            inv_id = doc["inventory_id_s"]
            doc["text_txt_en"] = "Access restricted. " + more_info_link(finding_aid.id, inv_id) + "."
          end
          finding_aid.add_child(doc, highlights)
        end
        results.items << finding_aid
      end
      results
    end

    def more_info_link(ead_id, inv_id)
      "<a href=\"/go-to-parent/#{ead_id}?inv_id=#{inv_id}\">More information</a>"
    end
end
