# RIAMCO v2
This is a proof of concept for the redesign of the [RIAMCO](http://www.riamco.org/) web site.


# Pre-requisites
We are currently using Ruby 2.3.5, Rails 4.2.x, SQLite, and Solr 7.

```
brew install ruby-install
brew install chruby
ruby-install ruby 2.3.5
source /usr/local/opt/chruby/share/chruby/chruby.sh
chruby 2.3.5
brew install mysql
gem install bundle
```

# To get started
```
git https://github.com/Brown-University-Library/riamco2.git
cd riamco2
bundle install
source .env_sample
bundle exec rake db:migrate
bundle exec rails server
```

Update the values in `.env_sample` to match the URLs where Solr is running in
your environment.


# Indexing our EAD files
```
bundle exec rake riamco:eads_to_solr[/path/to/xml/published/*.xml,true]
```

You can pass `false` as the second argument to skip the pushing of the data to Solr and instead get the JSON output on the console.

# General Architecture

# Solr Index
TODO: document the schema



