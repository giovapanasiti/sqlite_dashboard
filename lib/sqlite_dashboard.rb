require "sqlite_dashboard/version"
require "sqlite_dashboard/engine"
require "sqlite_dashboard/configuration"

module SqliteDashboard
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end