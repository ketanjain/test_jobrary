# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Viper_session',
  :secret      => '525c37b3bd742f3b113828c5bbc7b29d169eb270f31919942e7eea166412bc700cf88f2ebf505f59a71335c1f78b9e3ae27a0190279e3527606f64fd781c3f0a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
