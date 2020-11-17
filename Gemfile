source 'https://rubygems.org'

gem 'rails', '~> 6.0.2'

# In older servers this requires installing newer MySQL client libraries
# (e.g. rh-mysql57-mysql-devel ) and point the gem to them. For more
# information see https://github.com/brianmario/mysql2#configuration-options
#
# gem install mysql2 -v '0.5.3' --source 'https://rubygems.org/' -- --with-mysql-dir=/something/something/rh-mysql57/root/usr
#
gem "mysql2"

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

group :development, :test do
  gem "byebug"                # debugger
  gem "better_errors"         # web page for errors
  gem "binding_of_caller"     # allows inspecting values in web error page
  gem 'web-console', '~> 2.0' # Access an IRB console on exception pages or by using <%= console %> in views
end

# Needed on RedHat
gem 'therubyracer', platforms: :ruby

# Needed for rails console in RedHat
gem "rb-readline"

# Loads environment settings from .env file
# See https://github.com/bkeepers/dotenv
gem 'dotenv-rails'

gem "solr_lite", '0.0.14'
# gem "solr_lite", path: '/Users/hectorcorrea/dev/solr_lite'
