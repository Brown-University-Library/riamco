class SearchController < ApplicationController
  def index
    @presenter = execute_search()
    if @presenter.num_found == 0
        Rails.logger.warn("No results were found. Search: #{@presenter.search_qs}")
    end
    if params["format"] == "json"
      render :json => @presenter.results.to_json
      return
    end
    render "results"
  rescue => ex
    backtrace = ex.backtrace.join("\r\n")
    Rails.logger.error("Could not render search. Exception: #{ex} \r\n #{backtrace}")
    render "error", status: 500
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
      explain_query = request.params["explain"]
      debug = explain_query != nil

      params = SolrLite::SearchParams.from_query_string(request.query_string, facets_fields())
      params.q = "*" if params.q == ""
      params.page_size = 20 # don't allow the client to control this
      if params.q == "*"
        params.sort = "timestamp_s desc"
      end
      params.facet_limit = facet_limit if facet_limit != nil
      # TODO: add support for this params.def_fype = "edismax"

      searcher = Search.new(solr_url)
      search_results = searcher.search(params, debug)
      presenter = SearchResultsPresenter.new(search_results, params, search_url(), base_facet_search_url(), explain_query)
      presenter
    end

    def facets_fields()
      f = []
      f << SolrLite::FacetField.new("institution_s", "Institution")
      f << SolrLite::FacetField.new("subjects_ss", "Subject")
      f << SolrLite::FacetField.new("browse_terms_ss", "Browse Term")
      f << SolrLite::FacetField.new("languages_ss", "Language")
      f << SolrLite::FacetField.new("creators_ss", "Creator")
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
