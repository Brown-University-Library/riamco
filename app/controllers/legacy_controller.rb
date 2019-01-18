class LegacyController < ApplicationController
    def about
        redirect_to home_about_path()
    end

    def advanced_search
        redirect_to advanced_search_path()
    end

    def browse
        redirect_to home_browse_path()
    end

    def contact
        redirect_to home_contact_path()
    end

    def copyright
        redirect_to home_copyright_path()
    end

    def faq
        redirect_to home_faq_path()
    end

    def finding_aid
        redirect_to home_finding_aid_path()
    end

    def glossary
        redirect_to home_glossary_path()
    end

    def help
        redirect_to home_help_path()
    end

    def home
        redirect_to root_path()
    end

    def join
        redirect_to home_join_path()
    end

    def search
        redirect_to search_path()
    end

    def visit
        redirect_to home_visit_path()
    end
end
  