class HomeController < ApplicationController
  def about
    @nav_active = "nav_about"
    @presenter = HomePresenter.new()
  end

  def contact
    @nav_active = "nav_contact"
    @presenter = HomePresenter.new()
  end

  def copyright
    @presenter = HomePresenter.new()
  end

  def faq
    @presenter = HomePresenter.new()
  end

  def finding_aid
    @nav_active = "nav_help"
    @presenter = HomePresenter.new()
  end

  def glossary
    @nav_active = "nav_help"
    @presenter = HomePresenter.new()
  end

  def help
    @nav_active = "nav_help"
    @presenter = HomePresenter.new()
  end

  def help_advanced_search
    @presenter = HomePresenter.new()
  end

  def participating
    @nav_active = "nav_about"
    @presenter = HomePresenter.new()
  end

  def join
    @presenter = HomePresenter.new()
  end

  def index
    @nav_active = "nav_home"
    @presenter = HomePresenter.new()
  end

  def links
    @nav_active = "nav_about"
    @presenter = HomePresenter.new()
  end

  def page_not_found
    # Use the page title to track page not found in Google Analytics
    # (see https://www.practicalecommerce.com/Locating-404s-with-Google-Analytics)
    @page_title = "Page not found"
    err_msg = "Page #{request.url} was not found"
    Rails.logger.warn(err_msg)
    # Force to render as HTML
    render "not_found", status: 404, formats: [:html]
  end

  def resources
    @nav_active = "nav_about"
    @presenter = HomePresenter.new()
  end

  def status
    solr_url = ENV["SOLR_URL"]
    searcher = Search.new(solr_url)
    params = SolrLite::SearchParams.new()
    params.q = "*"
    search_results = searcher.search(params)
    if search_results.num_found > 0
      render :json => {status: "OK", message: "#{search_results.num_found} records found."}
    else
      error_id = SecureRandom.uuid
      Rails.logger.error("Error checking status (#{error_id}). No search results were found.")
      render :json => {status: "ERROR", message: "No search results were found (#{error_id})"}, status: 500
    end
  rescue => ex
    error_id = SecureRandom.uuid
    backtrace = ex.backtrace.join("\r\n")
    Rails.logger.error("Error checking status (#{error_id}). Exception: #{ex} \r\n #{backtrace}")
    render :json => {status: "ERROR", message: "Exception was found. See the log file (#{error_id})."}, status: 500
  end

  def visit
    @nav_active = "nav_help"
    @presenter = HomePresenter.new()
  end
end
