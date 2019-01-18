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

    def finding_aid
        redirect_to "/finding_aid"
    end

    def glossary
        redirect_to "/glossary"
    end

    def help
        redirect_to "/help"
    end

    def home
        redirect_to "/"
    end

    def visit
        redirect_to "/visit"
    end
end
  