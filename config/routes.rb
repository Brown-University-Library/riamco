Rails.application.routes.draw do
  # Redirect the original HTML and PHP pages
  # to the Rail pages.
  #
  # Notice that Apache will not let PHP requests
  # through if the PHP mod is installed and therefore
  # the Rail app will not see these requests. If that
  # is the case you'll need to create a redirect rule
  # in Apache or a stub PHP file inside the Rails app
  # (see public/render_302.php as an example)
  get 'about.html' => 'legacy#about'
  get 'advanced_search.html' => 'legacy#advanced_search'
  get 'browse.html' => 'legacy#browse'
  get 'contact.html' => 'legacy#contact'
  get 'copyright.html' => 'legacy#copyright'
  get 'faq.html' => 'legacy#faq'
  get 'finding_aid.html' => 'legacy#finding_aid'
  get 'glossary.html' => 'legacy#glossary'
  get 'help.html' => 'legacy#help'
  get 'index.html' => 'legacy#home'
  get 'links.html' => 'legacy#links'
  get 'render.php' => 'legacy#render'
  get 'resources.html' => 'legacy#resources'
  get 'search.php' => 'legacy#search'
  get 'visit.html' => 'legacy#visit'

  # New URLs (without .php or .html)
  get 'render' => 'ead#show', as: :ead_show
  get 'download' => 'ead#download', as: :ead_download

  get 'about' => 'home#about', as: :home_about
  get 'contact' => 'home#contact', as: :home_contact
  get 'copyright' => 'home#copyright', as: :home_copyright
  get 'faq' => 'home#faq', as: :home_faq
  get 'finding_aid' => 'home#finding_aid', as: :home_finding_aid
  get 'glossary' => 'home#glossary', as: :home_glossary
  get 'help' => 'home#help', as: :home_help
  get 'join' => 'home#join', as: :home_join
  get 'links' => 'home#links', as: :home_links
  get 'participating' => 'home#participating', as: :home_participating
  get 'resources' => 'home#resources', as: :home_resources
  get 'visit' => 'home#visit', as: :home_visit

  # Search URLs
  get 'advanced_search' => 'search#advanced_search', as: :advanced_search
  get 'search_facets' => 'search#facets'
  get 'search' => 'search#index', as: :search

  # POSSIBLE FUTURE ENHANCEMENT:
  #
  # In the future we could consider using a cleaner URL for the display of
  # the finding aids (e.g. /ead/id rather than /render.php?eadid=id) but if
  # we do that we need to update the path in the XSLT files to generate the
  # proper navigation links to the new path.
  #
  # Also, the finding aid ID contains periods and Rails does not supports
  # periods in the URL by default. We would need to use a constraint in the
  # route definition to support periods (see https://stackoverflow.com/a/23672925/446681)
  #
  # get 'ead/:id' => 'ead#show', as: :ead_show, constraints: { id: /[a-zA-Z0-9\.\-]+/ }

  # Home page
  root 'home#index'

  # For everything else, there's Master 404 Card.
  get '*path' => 'home#page_not_found'
end
