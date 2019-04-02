# RIAMCO v2
This is a proof of concept for the redesign of the RIAMCO.org web site.

You can see a preview at [https://apps.library.brown.edu/riamco/](https://apps.library.brown.edu/riamco/)


# Pre-requisites
We are currently using Ruby 2.3.5, Rails 4.2.x, SQLite, and Solr 7.

```
brew install ruby-install
brew install chruby
ruby-install ruby 2.3.5
source /usr/local/opt/chruby/share/chruby/chruby.sh
chruby 2.3.5
gem install bundle
```


# To get started
```
git https://github.com/Brown-University-Library/riamco.git
cd riamco
bundle install
source .env_sample
bundle exec rake db:migrate
bundle exec rails server
```

Update the values in `.env_sample` to match the URLs where Solr is running in
your environment.


# Indexing our EAD files
```
bundle exec rake riamco:ead_to_solr[/path/to/xml/published/*.xml,true]
```

You can pass `false` as the second argument to skip the pushing of the data to Solr and instead get the JSON output on the console.


# General Architecture
See [https://docs.google.com/document/d/1zQG6yT5sITz8JeCn4ILDOLy1nT5XAY6MwSRHm36Pwog/edit?usp=sharing](this document).


# Solr Index
The code to convert the finding aids from XML to Solr documents is in the `models/ead.rb` file.
