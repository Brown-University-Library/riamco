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
  get 'render_pending.php' => 'legacy#render_pending'
  get 'render.php' => 'legacy#render'
  get 'riamco/render.php' => 'legacy#render'
  get 'riamco/mkpdf.php' => 'legacy#render'
  get 'riamco/pdf_files/:filename' => 'legacy#pdf_files'
  get 'riamco/xml2pdffiles/:eadid' => 'legacy#render_pdf', constraints: { eadid: /[a-zA-Z0-9\.\-]+/ }
  get 'xml2pdffiles/:eadid' => 'legacy#render_pdf', constraints: { eadid: /[a-zA-Z0-9\.\-]+/ }
  get 'resources.html' => 'legacy#resources'
  get 'search.php' => 'legacy#search'
  get 'visit.html' => 'legacy#visit'

  # New URLs (without .php or .html)
  get 'render_pending' => 'ead#show_pending', as: :ead_show_pending
  get 'render' => 'ead#show', as: :ead_show
  get 'renderfile' => 'eadfile#show', as: :ead_show_file
  get 'download_pending' => 'ead#download_pending', as: :ead_download_pending
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
  get 'resources_other' => 'home#resources_other', as: :home_resources_other
  get 'resources' => 'home#resources', as: :home_resources
  get 'visit' => 'home#visit', as: :home_visit
  get 'status' => 'home#status', as: :home_status

  # Search URLs
  get 'advanced_proxy' => 'search#advanced_proxy', as: :advanced_proxy
  get 'advanced_parse' => 'search#advanced_parse', as: :advanced_parse
  get 'advanced_search' => 'search#advanced_search', as: :advanced_search
  get 'search_facets' => 'search#facets', as: :search_facets
  get 'search' => 'search#index', as: :search

  # File upload
  get 'upload' => 'upload#list', as: :upload_list
  get 'upload/form' => 'upload#form', as: :upload_form
  get 'upload/check_exists' => 'upload#check_exists', as: :upload_check_exists
  post 'upload/file' => 'upload#file', as: :upload_file
  post 'upload/publish' => 'upload#publish', as: :upload_publish
  post 'upload/delete' => 'upload#delete', as: :upload_delete

  # Authentication
  get 'login' => 'login#form', as: :login_form
  post 'login' => 'login#authenticate', as: :login_authenticate
  get 'logout' => 'login#logout', as: :login_logout

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
  root 'search#index'

  # For everything else, there's Master 404 Card.
  get '*path' => 'home#page_not_found'
end
