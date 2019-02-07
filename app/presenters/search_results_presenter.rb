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
    :debug, :show_facet_counts, :facet_count_url_toggle

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

    @num_eads = 0
    if @params.fq.count == 0 && @params.q == "*"
      @num_eads = FindingAids.count
    else
      eads = results.facets.find {|f| f.name=="title_s" }
      if eads != nil
        @num_eads = eads.values.count
      end
    end

    # from results
    @facets = results.facets

    @facets.each do |facet|
      # if facet.name == "start_year_i"
      #   # Sort by year, descending
      #   facet.values.sort_by! {|value| -(value.range_start || 0)}
      #   # Limit the year range to the present
      #   facet.values.each do |value|
      #     if value.text == "2000 - 2099"
      #       value.text = "2000 - present"
      #     end
      #   end
      # end
      if facet.name == "date_range_s"
        facet.values.sort_by! {|value| value.text}.reverse!
      end
    end

    @results = results.items
    set_urls_in_facets()
    set_remove_url_in_facets()

    @page = results.page
    @start = results.start

    @num_found = results.num_found
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

  private
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
        facet = @params.facet_for_field(fq.field)
        next if facet == nil

        # set the remove URL in the facet/value
        remove_url = @base_url + '?' + @params.to_user_query_string(fq)
        facet.set_remove_url_for(fq.value, remove_url)

        # ...and in the fq
        fq.title = facet.title
        fq.remove_url = remove_url
      end
    end
end
