class HomeController < ApplicationController
  def about
    @presenter = DefaultPresenter.new()
  end

  def advanced_search
    render text: "Advanced Search TBD"
  end

  def contact
    @presenter = DefaultPresenter.new()
  end

  def copyright
    @presenter = DefaultPresenter.new()
  end

  def faq
    @presenter = HomePresenter.new()
  end
  
  def finding_aid
    @presenter = HomePresenter.new()
  end

  def glossary
    @presenter = HomePresenter.new()
  end

  def help
    @presenter = DefaultPresenter.new()
  end

  def participating
    @presenter = DefaultPresenter.new()
  end

  def join
    @presenter = HomePresenter.new()
  end

  def index
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

  def visit
    @presenter = HomePresenter.new()
  end
end
