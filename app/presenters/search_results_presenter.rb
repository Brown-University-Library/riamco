require "cgi"

class SearchResultsPresenter

  # needed for *_show_url methods
  include Rails.application.routes.url_helpers

  attr_accessor :form_values, :fq, :facets, :query, :search_qs, :results,
    :page, :start, :end, :num_found, :num_pages, :page_start, :page_end, :num_eads,
    :previous_url, :next_url,
    :remove_q_url, :facetSearchBaseUrl,
    :suggest_q, :suggest_url,
    :explainer, :explain_format,
    :debug, :show_facet_counts, :facet_count_url_toggle,
    :fq_date_range,
    :fq_start_year, :start_year_from, :start_year_to,
    :sort, :sort_title_url, :sort_relevance_url

  # TODO: make this presenter inherit from DefaultPresenter to ensure this value exists
  attr_accessor :user

  def initialize(results, params, base_url, base_facet_search_url, explain_format)
    @debug = false
    @reading_room = nil
    @base_url = base_url
    @facetSearchBaseUrl = base_facet_search_url

    # Force all links to reset to page 1 so that if the user selects
    # a new facet or searches for a new term we show results starting
    # from page 1.
    params.page = 1

    # from params
    @params = params
    @form_values = @params.to_form_values()
    @fq = params.fq
    @query = params.q == "*" ? "" : CGI.unescape(params.q)
    @search_qs = params.to_user_query_string()
    @remove_q_url = "#{@base_url}?#{params.to_user_query_string_no_q()}"

    @suggest_q = results.spellcheck.top_collation_query()
    if results.spellcheck.top_collation_query != nil
      @suggest_url = @remove_q_url + "&q=#{CGI.escape(suggest_q)}"
    end

    @sort = "relevance"
    if (params.sort || "").include?("title_sort_s")
      @sort = "title"
    end
    @sort_title_url = "#{@base_url}?#{params.to_user_query_string()}&sort=title"
    @sort_relevance_url = "#{@base_url}?#{params.to_user_query_string()}&sort=rel"

    # from results
    @num_eads = results.groups_found || 0
    @facets = results.facets

    if home_page?()
      force_show_all_institutions()
    end
    @facets.each do |facet|
      case
      when facet.name == "date_range_s"
        facet.values.sort_by! {|value| value.text}.reverse!
      when facet.name == "institution_s"
        facet.values.sort_by! {|value| value.text}
      end
    end

    @results = results.items
    set_urls_in_facets()
    set_remove_url_in_facets()

    # Special values to handle filter by date via the Solr calculated
    # facets (date_range_s) and user's custom range (start_year_i)
    @fq_date_range = @fq.find {|fq| fq.field == "date_range_s"}
    @fq_start_year = @fq.find {|fq| fq.field == "start_year_i"}
    if fq_start_year != nil
      @start_year_from = @fq_start_year.range_from
      @start_year_to = @fq_start_year.range_to
    end

    @page = results.page
    @start = results.start

    @num_found = results.num_found
    if results.num_found == 0 && results.items.count > 0
      # When results are found only in the PDF files we need to
      # force these values since "results" come empty.
      # TODO: revisit this logic
      @num_found = results.items.count
      @num_eads = 1
    end

    # Calculate the number of pages based on the number of EADs
    # rather than on the number of matches.
    @num_pages = 0
    if results.page_size > 0
      @num_pages = (@num_eads / results.page_size).to_i
      @num_pages += 1 if (@num_eads % results.page_size) != 0
    end

    @end = [@start + results.page_size, @num_eads].min

    pages_to_display = 10
    if @num_pages < pages_to_display
      @page_start = 1
      @page_end = @num_pages
    else
      if @page + pages_to_display <= @num_pages
        @page_start = @page
        @page_end = @page + pages_to_display - 1
      else
        @page_start = @num_pages - pages_to_display + 1
        @page_end = @num_pages
      end
    end

    @previous_url = page_url(@page-1)
    @next_url = page_url(@page+1)

    @explain_format = explain_format
    @explainer = results.explainer

    @show_facet_counts = true
    @facet_count_url_toggle = ""
  end

  def empty_search?()
    @params.q == "*"
  end

  def home_page?()
    # no search terms and no facet selected
    @params.q == "*" && @fq.count == 0
  end

  def inventory_more_link(item, limit)
    return nil if item.match_count <= limit
    if item.match_count == (limit + 1)
      '<a target="_blank" href="render.php?eadid=' + item.ead_id + '&view=inventory">match</a>'
    else
      '<a target="_blank" href="render.php?eadid=' + item.ead_id + '&view=inventory">matches</a>'
    end
  end

  def pages_urls()
    @pages_urls ||= begin
      urls = []
      (1..@num_pages).each do |p|
        urls << page_url(p)
      end
      urls
    end
  end

  def page_url(page_number)
    qs = @search_qs.gsub(/page=[0-9]*/,"").chomp("&")
    "#{@base_url}?#{qs}&page=#{page_number}"
  end

  def inventory_url(ead_id)
    qs = @search_qs.gsub(/page=[0-9]*/,"").chomp("&")
    "#{@base_url}.json?#{qs}&inv_only=#{ead_id}"
  end

  def facet_expanded?(facet)
    # if facet.name == "institution_s"
    #   return true
    # end

    if facet.name == "date_range_s" && @fq_start_year != nil
      return true
    end

    facet.values.each do |v|
      if v.remove_url != nil
        return true
      end
    end

    false
  end

  def search_url()
    @base_url + "?" + @search_qs
  end

  def reading_room?()
    @reading_room ||= (@user != nil) && @user.is_reading_room?
  end

  private

    # Make sure all the institutions are represented in the `institution_s`
    # facet, even those that have no data. This list is hard-coded until
    # we figure out a good structure for the Institution model to support this.
    def force_show_all_institutions()
      facet = @facets.find {|facet| facet.name == "institution_s" }
      return if facet == nil
      facet.add_value("IYRS School of Technology & Trades Maritime Library", -1)
      facet.add_value("Jamestown Historical Society", -1)
      facet.add_value("Johnson & Wales University", -1)
      facet.add_value("Newport Art Museum", -1)
      facet.add_value("Providence City Archives", -1)
      facet.add_value("Roger Williams University School of Law", -1)
      facet.add_value("Tomaquag Museum ", -1)
    end

    def set_urls_in_facets()
      # this loops through _all_ the facet/values
      @facets.each do |f|
        f.values.each do |v|
          if f.range
            qs = @search_qs + "&fq=" + f.to_qs_range(v.range_start, v.range_end)
            v.add_url = @base_url + "?" + qs
          else
            qs = @search_qs + "&fq=" + f.to_qs(v.text)
            v.add_url = @base_url + "?" + qs
          end
        end
      end
    end

    def set_remove_url_in_facets()
      # this loops _only_ through the active filters
      @fq.each do |fq|
        remove_url = @base_url + '?' + @params.to_user_query_string(fq)

        facet = @params.facet_for_field(fq.field)
        if facet != nil
          # set the remove URL in the facet/value
          # ...and in the fq
          facet.set_remove_url_for(fq.value, remove_url)
          fq.title = facet.title
          fq.remove_url = remove_url
        else
          if fq.field == "start_year_i"
            # this is a known fq not in the facets...
            # ...set the remove URL only in the fq
            fq.title = "Date Range"
            fq.remove_url = remove_url
          end
        end
      end
    end
end
