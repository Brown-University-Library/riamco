# RIAMCO v2
Source code for the [Rhode Island Archival and Manuscript Collections Online](http://riamco.org) (RIAMCO) website.


# Pre-requisites
We are currently using Ruby 2.7.1, Rails 6.0.2, MySQL, and Solr 7.

```
brew install ruby-install
brew install chruby
ruby-install ruby 2.7.1
source /usr/local/opt/chruby/share/chruby/chruby.sh
chruby 2.7.1
gem install bundle
```

See `./solr_conf/solr_create.sh` for instructions on how to create the Solr core required by this project.


# To get started
Update the values in `.env_sample` to match the URLs where Solr is running in
your environment.

```
git https://github.com/Brown-University-Library/riamco.git
cd riamco
bundle install
source .env_sample
bundle exec rake db:migrate
bundle exec rails server
```


# Indexing our EAD files
```
bundle exec rake riamco:import_eads[/path/to/riamco/sampledata/*.xml]
```

You can use rake task `parse_eads` if you just want to parse an EAD and see the result in your Terminal.

The code to convert the finding aids from XML to Solr documents is in `./app/models/ead.rb` and `./app/models/ead_import.rb`.


# Indexing text from PDF files (optional)
If you are interested in indexing the *content* of the PDF files indicated in an EAD (in addition to the EAD itself) there are a few of extra steps required.

Download the Tika Server from the [Apache Tika website](http://tika.apache.org/download.html) and run it (leave it running)

```
curl http://apache.mirrors.tds.net/tika/tika-server-1.22.jar > tika-server-1.22.jar
java -jar tika-server-1.22.jar
```

Run the following Rake task to scan a particular EAD (by EAD ID) and index the PDF files indicated on it.

```
bundle exec rake riamco:ft_index_ead[US-RPB-ms2018.010]
```

The code to extract the content of the PDF files and index it in Solr is in `./app/models/full_text_import.rb`.


# Main classes
Most of the search logic is in `./app/controllers/search_controller.rb` and `./app/models/search.rb`.

The code to view individual finding aids is in `./app/controllers/ead_controller.rb` and relies heavily on the XSLT files under `./xslt/`.


# General Architecture

See [this document](https://docs.google.com/document/d/1zQG6yT5sITz8JeCn4ILDOLy1nT5XAY6MwSRHm36Pwog/).


