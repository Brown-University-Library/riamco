solr delete -c riamco2
solr create -c riamco2

bundle exec rake riamco:ead_to_solr[/Users/hectorcorrea/dev/riamco_php/xml/published/*.xml,true]