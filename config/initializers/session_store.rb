# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_sitedb_session',
  :secret      => '4cc86a3c115a98d7c884c060bea004168f2b33a6c6913a3652af0fce9cab2d3ea7e32d0bf23033dcf91bffdfcf9f5d7fb5ad54ae11049b5d53f9cd0e29239398'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
