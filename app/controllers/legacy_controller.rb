class LegacyController < ApplicationController
    def about
        redirect_to "/about"
    end

    def advanced_search
        redirect_to "/advanced_search"
    end

    def contact
        redirect_to "/contact"
    end

    def browse
        redirect_to "/search"
    end

    def help
        redirect_to "/help"
    end

    def home
        redirect_to "/index"
    end
end
  