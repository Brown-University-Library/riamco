class HomeController < ApplicationController
  def about
    @presenter = DefaultPresenter.new()
  end

  def advanced_search
    render text: "Advanced Search TBD"
  end

  def contact
    render text: "Contact TBD"
  end

  def help
    @presenter = DefaultPresenter.new()
  end

  def index
    @presenter = HomePresenter.new()
  end
end
