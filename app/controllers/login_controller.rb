class LoginController < ApplicationController
    skip_before_filter :verify_authenticity_token

    def form
        flash[:alert] = nil
    end

    def authenticate
        username = (params["username"] || "").strip
        password = (params["password"] || "").strip
        ok, user = User.authenticate(username, password)
        if ok
            session[:id] = user.id
            session[:username] = user.username
            Rails.logger.info("Login succeeded (#{username})")
            flash[:alert] = nil
            redirect_to upload_list_url()
        else
            session[:id] = nil
            session[:username] = nil
            Rails.logger.warn("Login failed (#{username})")
            flash[:alert] = "Invalid username and/or password entered"
            render "form", status: 401
        end
    end

    def logout
        session[:id] = nil
        session[:username] = nil
        flash[:alert] = "You have been logged out"
        redirect_to root_url()
    end
end