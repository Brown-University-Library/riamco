export SOLR_URL=http://localhost:8983/solr
export SOLR_CORE=riamco2

# Recreate the Solr core
#
# solr delete -c $SOLR_CORE
# solr create -c $SOLR_CORE


# Reload Solr core (needed after updating solrconfig.xml)
#
# curl "$SOLR_URL/admin/cores?action=RELOAD&core=$SOLR_CORE"


# Create "copy field" directive to copy all data to field _text_
# so that we can use this field for the spellchecker
# https://lucene.apache.org/solr/guide/7_6/solr-tutorial.html
#
# curl -X POST -H 'Content-type:application/json' \
# --data-binary '{"add-copy-field" : {"source":"*","dest":"_text_"}}' \
# $SOLR_URL/$SOLR_CORE/schema


# Delete the "copy field" directive.
#
# curl -X POST -H 'Content-type:application/json' \
# --data-binary '{"delete-copy-field":{ "source":"*", "dest":"_text_" }}' \
# $SOLR_URL/$SOLR_CORE/schema


# Reimport EAD files to Solr
#
# bundle exec rake riamco:ead_to_solr[/Users/hectorcorrea/dev/riamco_php/xml/published/*.xml,true]




