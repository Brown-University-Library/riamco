Rails.application.routes.draw do
  # Original PHP URLs.
  get 'render.php' => 'ead#show_legacy'
  get 'browse.html' => 'legacy#browse'
  get 'index.html' => 'legacy#home'
  get 'advanced_search.html' => 'legacy#advanced_search'
  get 'about.html' => 'legacy#about'
  get 'help.html' => 'legacy#help'
  get 'contact.html' => 'legacy#contact'
  get 'finding_aid.html' => 'legacy#finding_aid'
  get 'glossary.html' => 'legacy#glossary'
  get 'visit.html' => 'legacy#visit'

  # New URLs
  get 'advanced_search' => 'home#advanced_search'
  get 'about' => 'home#about', as: :home_about
  get 'help' => 'home#help', as: :home_help
  get 'contact' => 'home#contact', as: :home_contact
  get 'finding_aid' => 'home#finding_aid', as: :home_finding_aid
  get 'visit' => 'home#visit', as: :home_visit
  get 'glossary' => 'home#glossary', as: :home_glossary

  # # New display URL.
  # # 
  # # CAREFUL: If we change the path (e.g. add /ead/) we need to 
  # #          update the XSLT files to generate navigation links
  # #          to the new path.
  # # 
  # # We must use a constraint in the route definition to support periods 
  # # on the ID, something that Rails does not do by default
  # # (see https://stackoverflow.com/a/23672925/446681)
  # get 'ead/:id' => 'ead#show', as: :ead_show, constraints: { id: /[a-zA-Z0-9\.\-]+/ }

  # Search URLs
  get 'search_facets' => 'search#facets'
  get 'search' => 'search#index', as: :search

  # Home page
  root 'home#index'

  # For everything else, there's Master 404 Card.
  get '*path' => 'home#page_not_found'
end
