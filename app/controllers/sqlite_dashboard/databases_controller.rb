require 'sqlite3'

module SqliteDashboard
  class DatabasesController < ApplicationController
    before_action :set_database, only: [:show, :execute_query, :tables, :table_schema]

    def index
      @databases = SqliteDashboard.configuration.databases
    end

    def show
      @tables = fetch_tables
    end

    def execute_query
      @query = params[:query]

      Rails.logger.debug "=" * 80
      Rails.logger.debug "Execute Query Called"
      Rails.logger.debug "Request format: #{request.format}"
      Rails.logger.debug "Accept header: #{request.headers['Accept']}"
      Rails.logger.debug "Query: #{@query}"
      Rails.logger.debug "=" * 80

      begin
        @results = execute_sql(@query)
        Rails.logger.debug "Query executed successfully. Results: #{@results.inspect}"

        respond_to do |format|
          format.json do
            Rails.logger.debug "Rendering JSON response"
            render json: @results
          end
          format.turbo_stream do
            Rails.logger.debug "Rendering turbo_stream response"
            render :execute_query
          end
          format.html do
            Rails.logger.debug "Falling back to HTML redirect"
            redirect_to database_path(@database[:id])
          end
        end
      rescue => e
        @error = e.message
        Rails.logger.error "Query execution error: #{@error}"

        respond_to do |format|
          format.json do
            Rails.logger.debug "Rendering JSON error response"
            render json: { error: @error }, status: :unprocessable_entity
          end
          format.turbo_stream { render turbo_stream: turbo_stream.replace("query-results", partial: "sqlite_dashboard/databases/error", locals: { error: @error }) }
          format.html { redirect_to database_path(@database[:id]), alert: @error }
        end
      end
    end

    def tables
      tables = fetch_tables
      render json: tables
    end

    def table_schema
      table_name = params[:table_name]
      schema = fetch_table_schema(table_name)
      render json: schema
    end

    private

    def set_database
      @database = SqliteDashboard.configuration.databases.find { |db| db[:id] == params[:id].to_i }
      redirect_to databases_path, alert: "Database not found" unless @database
    end

    def database_connection
      @connection ||= SQLite3::Database.new(@database[:path])
    end

    def fetch_tables
      database_connection.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name").map { |row| row[0] }
    end

    def fetch_table_schema(table_name)
      database_connection.execute("PRAGMA table_info(#{table_name})").map do |row|
        {
          cid: row[0],
          name: row[1],
          type: row[2],
          notnull: row[3],
          dflt_value: row[4],
          pk: row[5]
        }
      end
    end

    def execute_sql(query)
      return { error: "Query cannot be empty" } if query.blank?

      # Always forbid DROP and ALTER operations
      if contains_destructive_ddl?(query)
        return { error: "DROP and ALTER operations are forbidden for safety reasons." }
      end

      # Check for DML operations if allow_dml is false
      unless SqliteDashboard.configuration.allow_dml
        if contains_dml?(query)
          return { error: "DML operations (INSERT, UPDATE, DELETE, CREATE, TRUNCATE) are not allowed. Set allow_dml to true in configuration to enable." }
        end
      end

      database_connection.results_as_hash = true
      results = database_connection.execute(query)

      if results.empty?
        { columns: [], rows: [], message: "Query executed successfully with no results" }
      else
        columns = results.first.keys
        rows = results.map(&:values)
        { columns: columns, rows: rows }
      end
    end

    def contains_destructive_ddl?(query)
      # Remove comments and normalize whitespace
      normalized_query = query.gsub(/--[^\n]*/, '').gsub(/\/\*.*?\*\//m, '').gsub(/\s+/, ' ').strip.upcase
      normalized_query =~ /\b(DROP|ALTER)\s+/
    end

    def contains_dml?(query)
      # Remove comments and normalize whitespace
      normalized_query = query.gsub(/--[^\n]*/, '').gsub(/\/\*.*?\*\//m, '').gsub(/\s+/, ' ').strip.upcase

      # Check for DML/DDL keywords (excluding DROP and ALTER which are always forbidden)
      dml_patterns = [
        /\bINSERT\s+INTO\b/,
        /\bUPDATE\s+/,
        /\bDELETE\s+FROM\b/,
        /\bCREATE\s+/,
        /\bTRUNCATE\s+/,
        /\bREPLACE\s+INTO\b/
      ]

      dml_patterns.any? { |pattern| normalized_query =~ pattern }
    end
  end
end