class SearchController < ApplicationController
  def index
    @nav_active = "nav_browse"
    @presenter = execute_search()
    if @presenter.num_found == 0
        Rails.logger.warn("No results were found. Search: #{@presenter.search_qs}")
    end
    if params["format"] == "json"
      render :json => @presenter.results.to_json
      return
    end
    @presenter.debug = request.params["debug"] == "true"
    if request.params["counts"] == "no"
      # Only include the facet counts if there are search terms
      @presenter.show_facet_counts = !@presenter.query.empty?
      @presenter.facet_count_url_toggle = "&counts=no"
    else
      @presenter.facet_count_url_toggle = "&counts=yes"
    end
    render "results"
  rescue => ex
    backtrace = ex.backtrace.join("\r\n")
    Rails.logger.error("Could not render search. Exception: #{ex} \r\n #{backtrace}")
    render "error", status: 500
  end

  def advanced_search
    @presenter = DefaultPresenter.new
  end

  # Returns the facet values (as JSON) for a search.
  # Use by the modals forms that show all values for a facet.
  def facets
    facet_name = request.params["f_name"]
    if facet_name == nil
      render :json => nil
      return
    end
    @presenter = execute_search(-1)
    facet_data = @presenter.facets.find {|f| f.name == facet_name }
    render :json => facet_data.values
  rescue => ex
    backtrace = ex.backtrace.join("\r\n")
    Rails.logger.error("Could not render facets as JSON. Exception: #{ex} \r\n #{backtrace}")
    render :json => nil, status: 500
  end

  private
    def execute_search(facet_limit = nil)
      solr_url = ENV["SOLR_URL"]
      flat_display = request.params["flat"] == "true"
      explain_query = request.params["explain"]
      debug = explain_query != nil

      params = SolrLite::SearchParams.from_query_string(request.query_string, facets_fields())
      params.q = "*" if params.q == ""
      params.page_size = 20 # don't allow the client to control this
      if params.q == "*"
        params.sort = "timestamp_s desc"
      end
      params.facet_limit = facet_limit if facet_limit != nil

      searcher = Search.new(solr_url)
      search_results = searcher.search(params, debug, flat_display)
      presenter = SearchResultsPresenter.new(search_results, params, search_url(), base_facet_search_url(), explain_query)
      presenter
    end

    def facets_fields()
      f = []
      f << SolrLite::FacetField.new("institution_s", "Institution")
      f << SolrLite::FacetField.new("title_s", "Finding Aid")
      f << SolrLite::FacetField.new("subjects_ss", "Subject")
      f << SolrLite::FacetField.new("browse_terms_ss", "Browse Term")
      # f << SolrLite::FacetField.new("inventory_level_s", "Level")
      f << SolrLite::FacetField.new("languages_ss", "Language")
      f << SolrLite::FacetField.new("creators_ss", "Creator")

      year = SolrLite::FacetField.new("start_year_i", "Date Range")
      year.range = true
      year.range_start = 0
      year.range_end = 3000
      year.range_gap = 100
      f << year

      f
    end

    def base_facet_search_url()
      # Base this value of the original search URL so that we preserve all
      # the search parameters.
      url = request.original_url.sub("/search", "/search_facets")
      if !url.include?("?")
        # This is to make sure we can safely add a query string parameter
        # (in the JavaScript used in the view) by just appending "&a=b".
        url += "?"
      end
      url
    end
end
