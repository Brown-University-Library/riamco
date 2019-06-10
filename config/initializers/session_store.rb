# Expire_after is in seconds:
#   30 days = 30 * 24 * 60 * 60 = 2592000
#    1 day  =  1 * 24 * 60 * 60 =   86400
Rails.application.config.session_store :cookie_store, key: '_riamco_session', :expire_after => 86400
