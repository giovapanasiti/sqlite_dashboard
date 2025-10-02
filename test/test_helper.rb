$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "sqlite_dashboard"

require "minitest/autorun"
require "rails"
require "sqlite3"

# Create a minimal Rails application for testing
class TestApp < Rails::Application
  config.root = __dir__
  config.eager_load = false
  config.session_store :cookie_store, key: "_test_session"
  config.secret_key_base = "test_secret"

  # Silence deprecation warnings
  config.active_support.deprecation = :log
end

TestApp.initialize!