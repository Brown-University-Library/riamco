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

  def finding_aid
    @presenter = HomePresenter.new()
  end

  def glossary
    @presenter = HomePresenter.new()
  end

  def help
    @presenter = DefaultPresenter.new()
  end

  def index
    @presenter = HomePresenter.new()
  end

  def visit
    @presenter = HomePresenter.new()
  end
end
