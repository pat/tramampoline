# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tramampoline_session',
  :secret      => '45a35ee4584c31134d42a2b64d8cdd68511198dd294cdb396f084545da576a5ad010db2b50765b3b793dd3e25de33373941329aea131133b8cd3fe4727a7482b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
