require "uri"

class LegacyController < ApplicationController
    def about
        redirect_to home_about_path()
    end

    def advanced_search
        redirect_to advanced_search_path()
    end

    def browse
        redirect_to search_path()
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

    def links
        redirect_to home_links_path()
    end

    def pdf_files
        new_url = "http://riamco.org"
        if params["filename"] && params["format"]
            new_url += "/pdf_files/" + params["filename"] + "." + params["format"]
        end
        redirect_to URI::encode(new_url)
    end

    def render
        eadid = request.params["eadid"]
        view = request.params["view"]
        redirect_to ead_show_path(eadid: eadid, view: view)
    end

    def render_pending
        eadid = request.params["eadid"]
        view = request.params["view"]
        redirect_to ead_show_pending_path(eadid: eadid, view: view)
    end

    def resources
        redirect_to home_resources_path()
    end

    def search
        redirect_to search_path()
    end

    def visit
        redirect_to home_visit_path()
    end
end
