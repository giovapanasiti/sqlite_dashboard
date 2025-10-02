# SQLite Dashboard Configuration
#
# Configure which SQLite databases you want to access through the dashboard.
# Only configure databases you trust, as this provides direct SQL access.

SqliteDashboard.configure do |config|
  # Array of database configurations
  # Each database should have a name and path
  config.db_files = [
    <% database_paths.each_with_index do |path, index| %>
    {
      name: "<%= index == 0 ? 'Development' : index == 1 ? 'Test' : "Database #{index + 1}" %>",
      path: <%= path %>
    }<%= index < database_paths.length - 1 ? ',' : '' %>
    <% end %>
  ]

  # You can also add databases dynamically:
  # config.add_database("Custom DB", "/path/to/custom.sqlite3")

  # Security Note:
  # For production use, wrap the mount in authentication:
  #
  # In config/routes.rb:
  # authenticate :user, ->(user) { user.admin? } do
  #   mount SqliteDashboard::Engine => "/sqlite_dashboard"
  # end
end