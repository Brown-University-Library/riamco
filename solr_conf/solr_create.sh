# solr delete -c riamco2
# solr create -c riamco2

# Copy all data to _text_ so that we can use the spellchecker
# https://lucene.apache.org/solr/guide/7_6/solr-tutorial.html
#
# curl -X POST -H 'Content-type:application/json' \
# --data-binary '{"add-copy-field" : {"source":"*","dest":"_text_"}}' \
# http://localhost:8983/solr/riamco2/schema

# bundle exec rake riamco:ead_to_solr[/Users/hectorcorrea/dev/riamco_php/xml/published/*.xml,true]