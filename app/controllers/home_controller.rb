class HomeController < ApplicationController
  def about
    render text: "About TBD"
  end

  def advanced_search
    render text: "Advanced Search TBD"
  end

  def contact
    render text: "Contact TBD"
  end

  def help
    render text: "Help TBD"
  end

  def index
    @presenter = DefaultPresenter.new()
  end
end
