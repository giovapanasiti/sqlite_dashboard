module SqliteDashboard
  class Engine < ::Rails::Engine
    isolate_namespace SqliteDashboard

    config.autoload_paths << File.expand_path("../../app/models", __FILE__)
    config.autoload_paths << File.expand_path("../../app/services", __FILE__)

    initializer "sqlite_dashboard.assets.precompile" do |app|
      app.config.assets.precompile += %w( sqlite_dashboard/application.js sqlite_dashboard/application.css )
    end

    initializer "sqlite_dashboard.importmap", before: "importmap" do |app|
      app.config.importmap.paths << root.join("config/importmap.rb") if app.config.respond_to?(:importmap)
    end
  end
end