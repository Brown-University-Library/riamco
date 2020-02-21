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
    return false if request == nil || request.remote_ip == nil
    return false if !current_user.is_reading_room?
    if !trusted_ip?(request.remote_ip)
      log_warn_request("reading room user outside of network")
      return false
    end
    return true
  end

  def trusted_ips
    @trusted_ips ||= begin
      (ENV["TRUSTED_IPS"] || "").chomp.split(",")
    end
  end

  def trusted_ip?(ip)
    return false if ip == nil
    trusted_ips.each do |trusted_value|
      if ip.start_with?(trusted_value)
        return true
      end
    end
    false
  end

  def log_warn_request(msg)
    req_info = "(no request info)"
    if request != nil && request.env != nil
      req_info = ""
      request.env.keys.each do |key|
        if key.start_with?("rack.") || key.start_with?("action_")
          next # ignore it
        end
        value = request.env[key]
        req_info += "#{key}=#{value}\r\n"
      end
    end
    Rails.logger.warn("#{msg}. Request: #{req_info}")
  end
end
