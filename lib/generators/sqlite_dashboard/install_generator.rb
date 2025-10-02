require 'rails/generators'

module SqliteDashboard
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Install SQLite Dashboard in your Rails application"

      source_root File.expand_path("templates", __dir__)

      def create_initializer
        template "initializer.rb", "config/initializers/sqlite_dashboard.rb"
      end

      def add_route
        route_content = <<-RUBY

  # SQLite Dashboard Engine
  mount SqliteDashboard::Engine => "/sqlite_dashboard"
        RUBY

        route route_content.strip
      end

      def display_readme
        readme "README" if behavior == :invoke
      end

      private

      def app_name
        Rails.application.class.module_parent_name.underscore
      end

      def database_paths
        paths = []

        # Common Rails database locations
        if File.exist?(Rails.root.join("storage", "development.sqlite3"))
          paths << 'Rails.root.join("storage", "development.sqlite3").to_s'
        end

        if File.exist?(Rails.root.join("db", "development.sqlite3"))
          paths << 'Rails.root.join("db", "development.sqlite3").to_s'
        end

        if File.exist?(Rails.root.join("storage", "test.sqlite3"))
          paths << 'Rails.root.join("storage", "test.sqlite3").to_s'
        end

        if File.exist?(Rails.root.join("db", "test.sqlite3"))
          paths << 'Rails.root.join("db", "test.sqlite3").to_s'
        end

        paths.empty? ? ['"/path/to/your/database.sqlite3"'] : paths
      end
    end
  end
end