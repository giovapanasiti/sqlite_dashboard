module SqliteDashboard
  class Configuration
    attr_accessor :db_files, :allow_dml

    def initialize
      @db_files = []
      @allow_dml = false
    end

    def add_database(name, path)
      @db_files << { name: name, path: path }
    end

    def databases
      # If no databases are configured, try to read from config/database.yml
      databases_list = @db_files.empty? ? load_from_database_yml : @db_files

      databases_list.map.with_index do |db, index|
        { id: index, name: db[:name] || File.basename(db[:path], ".*"), path: db[:path] }
      end
    end

    private

    def load_from_database_yml
      return [] unless defined?(Rails)

      database_yml_path = Rails.root.join("config", "database.yml")
      return [] unless File.exist?(database_yml_path)

      begin
        require 'yaml'
        require 'erb'

        yaml_content = ERB.new(File.read(database_yml_path)).result
        config = YAML.safe_load(yaml_content, aliases: true)

        current_env = Rails.env.to_s
        env_config = config[current_env]

        return [] unless env_config

        databases = []

        # Handle single database configuration
        if env_config['adapter'] == 'sqlite3' && env_config['database']
          database_path = resolve_database_path(env_config['database'])
          databases << {
            name: "#{current_env.titleize} DB",
            path: database_path
          } if database_path && File.exist?(database_path)
        end

        # Handle multiple databases configuration (Rails 6+)
        if env_config.key?('primary') || env_config.any? { |k, v| v.is_a?(Hash) && v['adapter'] }
          env_config.each do |key, db_config|
            next unless db_config.is_a?(Hash)
            next unless db_config['adapter'] == 'sqlite3'
            next unless db_config['database']

            database_path = resolve_database_path(db_config['database'])
            if database_path && File.exist?(database_path)
              db_name = key == 'primary' ? "#{current_env.titleize} DB" : "#{current_env.titleize} - #{key.titleize}"
              databases << {
                name: db_name,
                path: database_path
              }
            end
          end
        end

        databases
      rescue => e
        Rails.logger.warn("SqliteDashboard: Failed to load databases from database.yml: #{e.message}") if defined?(Rails.logger)
        []
      end
    end

    def resolve_database_path(database_path)
      return nil if database_path.blank?

      # Handle absolute paths
      return database_path if Pathname.new(database_path).absolute?

      # Handle relative paths
      Rails.root.join(database_path).to_s if defined?(Rails)
    end
  end
end