class EadController < ApplicationController
  def show
    @presenter = DefaultPresenter.new()
    render "show"
  end
end