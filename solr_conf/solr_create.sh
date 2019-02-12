export SOLR_URL=http://localhost:8983/solr
export SOLR_CORE=riamco2

# Recreate the Solr core
#
# solr delete -c $SOLR_CORE
# solr create -c $SOLR_CORE


# TODO: add definition for _txts_en

# Reload Solr core (needed after updating solrconfig.xml)
#
# curl "$SOLR_URL/admin/cores?action=RELOAD&core=$SOLR_CORE"


# Reimport EAD files to Solr
#
# bundle exec rake riamco:ead_to_solr[/Users/hectorcorrea/dev/riamco_php/xml/published/*.xml,true]




