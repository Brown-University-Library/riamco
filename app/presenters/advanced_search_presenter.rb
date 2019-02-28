require "cgi"

class AdvancedSearchPresenter

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
    :fq_start_year, :start_year_from, :start_year_to

  def initialize(results, params, base_url, base_facet_search_url, explain_format)
    @debug = false
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

    # For the facets we exclude the title and the date range since these are
    # free form fields in the advanced search form.
    @facets = results.facets.select {|f| f.name != "title_s" && f.name != "date_range_s" }

    @results = results.items
    set_urls_in_facets()
    set_remove_url_in_facets()

    # Special values to handle filter by date via the Solr calculated
    # facets (date_range_s) and user's custom range (start_year_i)
    @fq_date_range = @fq.find {|fq| fq.field == "date_range_s"}
    @fq_start_year = @fq.find {|fq| fq.field == "start_year_i"}
    if fq_start_year != nil
      # TODO: remove this logic once FilterQuery is capable of returning
      # range from and to values.
      tokens = fq_start_year.value.split(" - ")
      if tokens.count == 2
        @start_year_from = tokens[0].gsub("*","")
        @start_year_to = tokens[1].gsub("*","")
      end
    end

    @page = results.page
    @start = results.start

    @num_found = results.num_found
    @num_pages = 0
    @end = 0

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

    # @previous_url = page_url(@page-1)
    # @next_url = page_url(@page+1)

    @explain_format = explain_format
    @explainer = results.explainer

    @show_facet_counts = true
    @facet_count_url_toggle = ""
  end

  def empty_search?()
    @params.q == "*"
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

  private
    def set_urls_in_facets()
      # this loops through _all_ the facet/values
      @facets.each do |f|
        sequence = 0
        f.values.each do |v|
          # TODO: Revisit this.
          #
          # We overload the add_url field to have the key that we use for this
          # value in the checkboxes show in the Advanced Search.
          sequence += 1
          value_key = "#{f.name}_#{sequence}"
          v.add_url = value_key
        end
      end
    end

    def set_remove_url_in_facets()
    end
end
