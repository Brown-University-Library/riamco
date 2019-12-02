# RIAMCO v2
Source code for the [Rhode Island Archival and Manuscript Collections Online](http://riamco.org) (RIAMCO) website.


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

See `./solr_conf/solr_create.sh` for instructions on how to create the Solr core required by this project.


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
bundle exec rake riamco:import_eads[/path/to/xml/published/*.xml]
```

You can use rake task `parse_eads` if you just want to parse to an EAD and see the result in your Terminal.


# Indexing text from PDF files (optional)
If you are interested in indexing the *content* of the PDF files indicated in an EAD (in addition to the EAD itself) there are a few of extra steps required.

Download the Tika Server from the [Apache Tika website](http://tika.apache.org/download.html) and run it (leave it running)

```
curl http://apache.mirrors.tds.net/tika/tika-server-1.22.jar > tika-server-1.22.jar
java -jar tika-server-1.22.jar
```

Create a separate Solr core to store the contents of the PDF files extracted with Tika:

```
solr create -c riamco_pdf_text
```

Run the following Rake task to scan a particular EAD (by EAD ID) and index the PDF files indicated on it.

```
bundle exec rake riamco:ft_index_ead[US-RPB-ms2018.010]
```


# General Architecture

See [this document](https://docs.google.com/document/d/1zQG6yT5sITz8JeCn4ILDOLy1nT5XAY6MwSRHm36Pwog/).


# Solr Index
The code to convert the finding aids from XML to Solr documents is in the `./app/models/ead.rb` file.
