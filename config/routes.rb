Rails.application.routes.draw do
  # Search URLs
  get 'search_facets' => 'search#facets'
  get 'search' => 'search#index', as: :search

  # Home page
  root 'home#index'

  # For everything else, there's Master 404 Card.
  get '*path' => 'home#page_not_found'
end
