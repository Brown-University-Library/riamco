class HomeController < ApplicationController
  def about
  end

  def help
  end

  def index
    @presenter = DefaultPresenter.new()
  end
end
