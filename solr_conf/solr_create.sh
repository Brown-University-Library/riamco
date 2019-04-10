export SOLR_URL=http://localhost:8983/solr
export SOLR_CORE=riamco2

# Recreate the Solr core
#
# solr delete -c $SOLR_CORE
# solr create -c $SOLR_CORE

#
# This is needed for field creators_txts_en
#
curl -X POST -H 'Content-type:application/json' --data-binary '{
  "add-dynamic-field":{
    "name":"*_txts_en",
    "type":"text_en",
    "multiValued":true
  }
}' $SOLR_URL/$SOLR_CORE/schema

# Reload Solr core (needed after updating solrconfig.xml)
#
# curl "$SOLR_URL/admin/cores?action=RELOAD&core=$SOLR_CORE"


# Reimport EAD files to Solr
#
# bundle exec rake riamco:ead_to_solr[/Users/hectorcorrea/dev/riamco_php/xml/published/*.xml,true]




