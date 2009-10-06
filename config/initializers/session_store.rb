# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_peas_session',
  :secret      => '684be33c674d6092a36c3dab9d6171a8639e3b9327c1f7c66c17adf413dbdf91831f4988a5aeb21a2556a41d5a813cabd45a259062353fadfd92df8ce3d1fd92'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
