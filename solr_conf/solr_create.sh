export SOLR_URL=http://localhost:8983/solr
export SOLR_CORE=riamco
export SOLR_PORT=8983

# Recreate the Solr core
#
# solr delete -c $SOLR_CORE
solr create -c $SOLR_CORE -p $SOLR_PORT


# Prevent automatic creation of fields
#
solr config -c $SOLR_CORE -p $SOLR_PORT -action set-user-property -property update.autoCreateFields -value false


# Create a new dynamic field (to allow for fields file creators_txts_en)
#
curl -X POST -H 'Content-type:application/json' --data-binary '{
  "add-dynamic-field":{
    "name":"*_txts_en",
    "type":"text_en",
    "multiValued":true
  }
}' $SOLR_URL/$SOLR_CORE/schema

# OPTIONAL:
#
# To enable the spell checker in RIAMCO see solrconfig_changes.xml
# for the changes that are need in Solr's configuration.
#
# This is an optional step for local development.
#
# Reload Solr core (needed after updating solrconfig.xml)
# curl "$SOLR_URL/admin/cores?action=RELOAD&core=$SOLR_CORE"
#