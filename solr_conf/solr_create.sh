solr delete -c riamco2
solr create -c riamco2

# curl -X POST -H 'Content-type:application/json' --data-binary '{
#   "add-dynamic-field":{
#     "name":"*_txts_en",
#     "type":"text_en",
#     "multiValued":true
#   }
# }' http://localhost:8983/solr/riamco2/schema

bundle exec rake riamco:eads_to_solr[/Users/hectorcorrea/dev/riamco_php/xml/published/*.xml,true]