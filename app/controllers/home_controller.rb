class HomeController < ApplicationController
  def about
    @nav_active = "nav_about"
    @presenter = HomePresenter.new()
  end

  def advanced_search
    @nav_active = "nav_advanced"
    render text: "Advanced Search TBD"
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

  def visit
    @nav_active = "nav_help"
    @presenter = HomePresenter.new()
  end
end
