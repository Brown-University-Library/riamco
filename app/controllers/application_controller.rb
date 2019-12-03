class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    return nil if session[:id] == nil || session[:id] == 0
    @current_user ||= begin
      User.find_by_id(session[:id])
    end
  end

  def is_reading_room?
    return false if current_user == nil
    current_user.is_reading_room?
  end
end
