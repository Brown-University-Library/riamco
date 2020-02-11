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
    qf += "subjects_txts_en formats_txts_en keywords_t"

    params.hl = true
    params.hl_fl = "filing_title_s title_txt_en abstract_txt_en scope_content_txts_en subjects_txts_en formats_txts_en biog_hist_txt_en "
    params.hl_fl += "inventory_label_txt_en inventory_scope_content_txt_en"
    params.hl_snippets = 30

    params.spellcheck = true

    results = search_grouped(params, extra_fqs, qf, mm, debug, limit_to)

    if search_files_allowed?(params)
      # Repeat the search but now within the PDF files indexed for the finding aid.
      # TODO: Remove hardcoded logic
      ead_id = "US-RPB-ms2018.010"
      file_results, files_count = search_files(ead_id, params.q, limit_to, user)
      results = merge_search_results(ead_id, results, file_results, files_count)
    end

    results
  end

  # Runs a search on the text of the files (which is a separate Solr core)
  # Notice that the results of this search are flat, not grouped.
  def search_files(ead_id, q, page_size, user)
    logger = ENV["SOLR_VERBOSE"] == "true" ? Rails.logger : nil
    solr_url = ENV["SOLR_TEXT_URL"]
    solr = SolrLite::Solr.new(solr_url, logger)
    solr.def_type = "edismax"

    is_reading_room = user != nil && user.is_reading_room?

    extra_fqs = []
    extra_fqs << SolrLite::FilterQuery.new("ead_id_s", [ead_id])
    params = SolrLite::SearchParams.new()
    params.fq = []
    params.fl = nil
    params.q = q
    qf = "text_txt_en"
    params.hl = true
    params.hl_fl = "text_txt_en"
    params.hl_snippets = 4
    params.spellcheck = true
    if page_size != nil
      params.page_size = page_size
    end
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
      file_info = get_file_info(doc)
      doc2 = {
        "id" => id,
        "ead_id_s" => doc["ead_id_s"],
        "inventory_level_s" => "Digital"
      }

      highlights = results.highlights.for(id) || []
      highlights2 = {"text_txt_en" => highlights["text_txt_en"]}
      if !is_reading_room
        # Don't return the highlights
        highlights2 = {"text_txt_en" => ["Access is restricted to reading room users."]}
      end

      item = SearchItem.from_hash(doc2, highlights2)
      # TODO: review if file_text is used at all
      # if is_reading_room
      #   item.file_text = doc["text_txt_en"]
      # else
      #   # Don't return the text
      #   item.file_text = "Access is restricted to reading room users."
      # end
      item.inv_id = file_info[:inv_id]
      item.inv_filename = file_info[:name]
      item.inv_label = file_info[:label]
      item.inv_filedesc = file_info[:description]
      items << item
    end
    return items, results.num_found
  end

  # Finds file metadata for a given inventory_filename
  def file_metadata(ead_id, inventory_filename)
    logger = ENV["SOLR_VERBOSE"] == "true" ? Rails.logger : nil
    solr_url = ENV["SOLR_URL"]
    solr = SolrLite::Solr.new(solr_url, logger)
    solr.def_type = "edismax"

    params = SolrLite::SearchParams.new()
    fq = SolrLite::FilterQuery.new("ead_id_s", [ead_id])
    params.fq = [fq]
    params.fl = nil
    params.q = inventory_filename
    extra_fqs = []
    qf = "inventory_filename_s"
    debug = false
    mm = nil
    results = solr.search(params, extra_fqs, qf, mm, debug)
    if !results.ok?
      raise("Solr reported: #{results.error_msg}")
    end

    if results.solr_docs.count != 1
      search_key = "#{ead_id} / #{inventory_filename}"
      Rails.logger.error("get_file_metadata: #{results.solr_docs.count} results found for #{search_key}.")
      return nil
    end

    finding_aid_doc = FindingAids.by_id(ead_id)
    if finding_aid_doc == nil
      Rails.logger.error("get_file_metadata: could not fetch finding aid info (#{ead_id}).")
      return nil
    end

    info = {
        ead_id: finding_aid_doc["ead_id_s"],
        ead_title: finding_aid_doc["title_txt_en"],
        name: results.solr_docs[0]["inventory_filename_s"],
        label: results.solr_docs[0]["inventory_label_txt_en"],
        description: results.solr_docs[0]["inventory_file_description_txt_en"],
        inv_id: results.solr_docs[0]["inventory_id_s"]
      }
    info
  end

  private
    # Finds the file information in SOLR_URL for a given document found in SOLR_TEXT_URL
    #
    # This is so that we can return the metadata information (original filename, description)
    # of the file found in SOLR_TEXT_URL.
    def get_file_info(doc)
      logger = ENV["SOLR_VERBOSE"] == "true" ? Rails.logger : nil
      solr_url = ENV["SOLR_URL"]
      solr = SolrLite::Solr.new(solr_url, logger)
      solr.def_type = "edismax"

      ead_id = doc["ead_id_s"]
      extra_fqs = []
      extra_fqs << SolrLite::FilterQuery.new("ead_id_s", [ead_id])
      params = SolrLite::SearchParams.new()
      params.fq = []
      params.fl = nil
      params.q = doc["inventory_filename_s"]
      qf = "inventory_filename_s"
      debug = false
      mm = nil
      results = solr.search(params, extra_fqs, qf, mm, debug)
      if !results.ok?
        raise("Solr reported: #{results.error_msg}")
      end

      info = {}
      if results.solr_docs.count == 1
        info = {
          id: results.solr_docs[0]["id"],
          inv_id: results.solr_docs[0]["inventory_id_s"],
          name: results.solr_docs[0]["inventory_filename_s"],
          label: results.solr_docs[0]["inventory_label_txt_en"],
          description: results.solr_docs[0]["inventory_file_description_txt_en"]
        }
      else
        search_key = "#{ead_id} / #{doc['inventory_filename_s']}"
        Rails.logger.warn("#{results.solr_docs.count} results found for #{search_key}.")
        info = {
          id: doc["id"],
          inv_id: doc["inventory_id_s"],
          name: doc["inventory_filename_s"],
          label: doc["inventory_filename_s"],
          description: doc["inventory_filename_s"]
        }
      end
      info
    end


    # Merges the `file_results` from SOLR_TEXT_URL with the `results` from SOLR_URL.
    def merge_search_results(ead_id, results, file_results, files_count)
      if file_results.count == 0
        return results
      end

      # TODO: Remove hardcoded logic
      ead_bornstein = results.items.find{|item| item.id == "US-RPB-ms2018.010"}
      if ead_bornstein == nil
        # If we didn't pick up the finding aid info in the finding aids search
        # but we got results in the files search, load the finding aid info.
        finging_aid_doc = FindingAids.by_id("US-RPB-ms2018.010")
        if finging_aid_doc == nil
          raise("Error getting finding aid with id: #{group_id}")
        end
        ead_bornstein = SearchItem.from_hash(finging_aid_doc, {})
        results.items << ead_bornstein
      end

      # Append the file_results to the Borstein EAD in the results.
      eads_count = results.items.map {|i| i.ead_id}.count
      if eads_count == 1
        # We only have one finding aid in the result set, use all the file results
        ead_bornstein.children += file_results
      else
        # We have many finding aids in the result set, use only the
        # first 4 results from the file search
        ead_bornstein.children += file_results.first(4)
      end

      # Append the number of files found to the total match count.
      ead_bornstein.match_count += files_count

      results
    end


    def search_files_allowed?(params)
      if ENV["SOLR_TEXT_URL"] == nil
        return false
      end

      # User is explicitly working with the Borstein collection then it's OK
      # to search within files.
      # TODO: Remove hardcoded logic
      fq_title = params.fq.find {|fq| fq.field == "title_s"}
      if fq_title != nil && fq_title.value == "Kate Bornstein papers"
        return true
      end

      # User has not filtered by any facet it's OK to search within files
      # as long as we are on the first page
      if params.fq.count == 0 && params.page == 1
        return true
      end

      # Don't search within files since we cannot guarantee that the results
      # will make sense with any of the other facets that the user might
      # have selected (e.g. collections from an institution other than Brown)
      false
    end


    # Issues the search and groups the results.
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
