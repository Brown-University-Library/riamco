require "./app/models/query_parser.rb"

class SearchController < ApplicationController
  def index
    @nav_active = "nav_browse"
    @presenter = execute_search()
    if @presenter.num_found == 0
      msg = "No results were found. Search: #{@presenter.search_qs}. "
      if @presenter.suggest_url != nil
        msg += "Spellcheck: #{@presenter.suggest_q}"
      end
      Rails.logger.warn(msg)
    end
    if params["format"] == "json"
      render :json => @presenter.results.to_json
      return
    end
    @presenter.debug = request.params["debug"] == "true"
    render "results"
  rescue => ex
    backtrace = ex.backtrace.join("\r\n")
    Rails.logger.error("Could not render search. Exception: #{ex} \r\n #{backtrace}")
    render "error", status: 500
  end

  def advanced_search
    solr_url = ENV["SOLR_URL"]
    flat_display = request.params["flat"] == "true"
    explain_query = nil
    debug = false

    params = SolrLite::SearchParams.from_query_string(request.query_string, facets_fields())
    params.q = "*" if params.q == ""
    params.page_size = 10 # don't allow the client to control this

    searcher = Search.new(solr_url)
    search_results = searcher.search(params, debug, flat_display)
    @presenter = AdvancedSearchPresenter.new(search_results, params, search_url(), base_facet_search_url(), explain_query)
  end

  # Parses the values in the request and returns the Solr query
  # that will be executed with those values.
  def advanced_parse
    begin
      data = {
        all_fields: search_value(params["all_fields"], "all_fields"),
        title: search_value(params["title"], "title"),
        call_no: search_value(params["call_no"], "call_no"),
        abstract: search_value(params["abstract"], "abstract"),
        year_range: search_value_range(params["year_from"], params["year_to"], "start_year")
      }
      render :json => data.to_json
    rescue => ex
      backtrace = ex.backtrace.join("\r\n")
      Rails.logger.error("Error validating expression. Exception: #{ex} \r\n #{backtrace}")
      render :json => {}, status: 400
    end
  end

  # Transforms the parameters in the advanced search to the proper Solr
  # parameters and executes the search via the normal search URL.
  def advanced_proxy
    match_type = params["match_type"] == "OR" ? " OR " : " AND "
    q_values = []
    q_values << search_value(params["all_fields"], nil)
    q_values << search_value(params["title_txt_en"], "title_txt_en")
    q_values << search_value(params["call_no_s"], "call_no_s")
    q_values << search_value(params["abstract_txt_en"], "abstract_txt_en")
    q_values << search_value_range(params["year_from"], params["year_to"], "start_year_i")
    q = q_values.compact.join(match_type)

    fq_values = []
    facets = ["institution_s", "creators_ss", "subjects_ss", "formats_ss", "languages_ss"]
    facets.each do |facet_name|
      values = []
      params.keys.each do |key|
        if key.start_with?(facet_name + "_")
          values << params[key]
        end
      end
      if values.count > 0
        fq_values << facet_name + "|" + values.join("|")
      end
    end

    url = search_url(q:q)
    fq_values.each do |fq|
      url += "&fq=" + fq
    end
    redirect_to url
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
      explain_query = nil # request.params["explain"]
      debug = explain_query != nil

      params = SolrLite::SearchParams.from_query_string(request.query_string, facets_fields())
      params.q = "*" if params.q == ""
      params.page_size = 10 # don't allow the client to control this
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
      inst = SolrLite::FacetField.new("institution_s", "Institution")
      inst.limit = 30
      f << inst
      f << SolrLite::FacetField.new("creators_ss", "Creator")
      f << SolrLite::FacetField.new("date_range_s", "Date Range")
      f << SolrLite::FacetField.new("subjects_ss", "Subject")
      f << SolrLite::FacetField.new("formats_ss", "Format")
      f << SolrLite::FacetField.new("languages_ss", "Language")
      f << SolrLite::FacetField.new("title_s", "Collection")
      f
    end

    def base_facet_search_url()
      # Base this value of the original search URL so that we preserve all
      # the search parameters.
      url = request.original_url
      if url.include?("/search")
        url = url.sub("/search", "/search_facets")
      elsif url.include?("/advanced_search")
        url = url.sub("/advanced_search", "/search_facets")
      end
        if !url.include?("?")
        # This is to make sure we can safely add a query string parameter
        # (in the JavaScript used in the view) by just appending "&a=b".
        url += "?"
      end
      url
    end

    # Converts a value and field to the proper Solr search syntax.
    # For example:
    #   hello world   => field:hello OR field:world
    #   "hello world" => field:"hello world"
    def search_value(value, field)
      if value == nil || value.strip.empty?
        return nil
      end
      # Encode to prevent HTML injection but preserve quotes (otherwise
      # the parser won't detect phrases) and single quotes (since that's
      # a common and harmless search character)
      encoded = ERB::Util.h(value)
      encoded.gsub!("&quot;", "\"")
      encoded.gsub!("&#39;", "'")
      parser = QueryParser.new(encoded)
      if field == nil
        parser.to_query()
      else
        parser.to_solr_query(field)
      end
    end

    def search_value_range(from, to, field)
      from = (from != nil && from.strip.empty?) ? nil : from
      to = (to != nil && to.strip.empty?) ? nil : to
      case
      when from == nil && to == nil
        return nil
      when from != nil && to == nil
        return "#{field}:[#{from} TO *]"
      when from == nil && to != nil
        return "#{field}:[* TO #{to}]"
      else
        return "#{field}:[#{from} TO #{to}]"
      end
    end
end
