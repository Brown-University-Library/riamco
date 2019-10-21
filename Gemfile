source 'https://rubygems.org'

gem 'rails', '~> 4.2.11'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# group :production do
#   # Rails 4.x must stay within MySQL 0.4
#   # https://github.com/brianmario/mysql2/issues/950#issuecomment-376375844
#   # gem 'mysql2', '< 0.5'
# end

group :development, :test do
  gem "byebug"                # debugger
  gem "better_errors"         # web page for errors
  gem "binding_of_caller"     # allows inspecting values in web error page
  gem 'web-console', '~> 2.0' # Access an IRB console on exception pages or by using <%= console %> in views
end

gem 'sqlite3', git: "https://github.com/larskanis/sqlite3-ruby", branch: "add-gemspec"

# Needed on RedHat
gem 'therubyracer', platforms: :ruby
gem "tzinfo-data"

# Needed for rails console in RedHat
gem "rb-readline"

# Loads environment settings from .env file
# See https://github.com/bkeepers/dotenv
gem 'dotenv-rails'

gem "solr_lite", '0.0.14'
# gem "solr_lite", path: 'C:\Users\cross9\Downloads\solr_lite-master'
