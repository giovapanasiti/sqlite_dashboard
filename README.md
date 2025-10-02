# SQLite Dashboard

[![Gem Version](https://badge.fury.io/rb/sqlite_dashboard.svg)](https://badge.fury.io/rb/sqlite_dashboard)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A beautiful, feature-rich SQLite database browser and query interface for Rails applications. Mount it as an engine in your Rails app to inspect and query your SQLite databases through a clean, modern interface.

![SQLite Dashboard Screenshot](https://via.placeholder.com/800x400)

## Features

- 🎨 **Modern UI** with Bootstrap 5 and responsive design
- 🔍 **Multiple Database Support** - Configure and switch between multiple SQLite databases
- ✨ **SQL Syntax Highlighting** - CodeMirror editor with SQL syntax highlighting and autocomplete
- 📊 **Interactive Query Results** - Paginated, sortable results with horizontal scrolling
- 🎯 **Quick Table Browse** - Click any table name to instantly query it
- ⚡ **Fast & Lightweight** - No build tools required, works with Rails importmap
- 🔐 **Safe for Development** - Read-only access to prevent accidental data modification
- ⌨️ **Keyboard Shortcuts** - `Ctrl/Cmd + Enter` to execute queries

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sqlite_dashboard'
```

And then execute:

```bash
$ bundle install
```

## Configuration

### Step 1: Mount the Engine

In your `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  mount SqliteDashboard::Engine => "/sqlite_dashboard"

  # Your other routes...
end
```

### Step 2: Configure Databases

Create an initializer `config/initializers/sqlite_dashboard.rb`:

```ruby
SqliteDashboard.configure do |config|
  config.db_files = [
    {
      name: "Development",
      path: Rails.root.join("storage", "development.sqlite3").to_s
    },
    {
      name: "Test",
      path: Rails.root.join("storage", "test.sqlite3").to_s
    }
  ]

  # Or add databases dynamically:
  # config.add_database("Custom DB", "/path/to/database.sqlite3")
end
```

### Step 3: Access the Dashboard

Start your Rails server and navigate to:

```
http://localhost:3000/sqlite_dashboard
```

## Usage

### Basic Query Execution

1. Select a database from the main page
2. Write your SQL query in the syntax-highlighted editor
3. Press `Execute Query` or use `Ctrl/Cmd + Enter`
4. View paginated results below

### Quick Table Browse

- Click any table name in the left sidebar to instantly query it
- Tables are automatically limited to 100 rows for performance

### Pagination Controls

- Adjust rows per page (10, 25, 50, 100, 500)
- Navigate through pages with First, Previous, Next, Last buttons
- See current position (e.g., "Showing 1 to 25 of 150 rows")

### Keyboard Shortcuts

- `Ctrl/Cmd + Enter` - Execute current query
- `Ctrl + Space` - Trigger SQL autocomplete
- `Escape` - Close autocomplete suggestions

## Security Considerations

⚠️ **Warning**: This gem provides direct SQL access to your databases.

### Recommended Security Measures:

1. **Development Only** - Only mount in development environment:

```ruby
# config/routes.rb
if Rails.env.development?
  mount SqliteDashboard::Engine => "/sqlite_dashboard"
end
```

2. **Authentication** - Add authentication with Devise or similar:

```ruby
# config/routes.rb
authenticate :user, ->(user) { user.admin? } do
  mount SqliteDashboard::Engine => "/sqlite_dashboard"
end
```

3. **Basic Auth** - Quick protection with HTTP Basic Auth:

```ruby
# config/initializers/sqlite_dashboard.rb
SqliteDashboard::Engine.middleware.use Rack::Auth::Basic do |username, password|
  username == ENV['DASHBOARD_USER'] && password == ENV['DASHBOARD_PASS']
end
```

4. **Read-Only Mode** - Configure read-only database connections:

```ruby
config.db_files = [
  {
    name: "Production (Read-Only)",
    path: Rails.root.join("db/production.sqlite3").to_s,
    readonly: true  # Coming in v2.0
  }
]
```

## Customization

### Custom Styling

Override styles by creating `app/assets/stylesheets/sqlite_dashboard_overrides.css`:

```css
.sqlite-dashboard-container {
  /* Your custom styles */
}

.CodeMirror {
  /* Customize editor appearance */
  font-family: 'Fira Code', monospace;
  font-size: 14px;
}
```

### Configuration Options

```ruby
SqliteDashboard.configure do |config|
  # Database files
  config.db_files = []

  # Future options (v2.0):
  # config.readonly = true
  # config.max_results = 10000
  # config.enable_export = true
  # config.theme = :dark
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests.

To install this gem onto your local machine, run:

```bash
bundle exec rake install
```

To release a new version:

1. Update the version number in `version.rb`
2. Update the CHANGELOG.md
3. Run `bundle exec rake release`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yourusername/sqlite_dashboard. This project is intended to be a safe, welcoming space for collaboration.

### Development Setup

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Running Tests

```bash
bundle exec rspec
```

## Roadmap

- [ ] **v1.1** - Export results to CSV/JSON
- [ ] **v1.2** - Query history and saved queries
- [ ] **v1.3** - Database schema visualization
- [ ] **v2.0** - Read-only mode enforcement
- [ ] **v2.1** - Dark mode theme
- [ ] **v2.2** - Multi-query execution
- [ ] **v2.3** - Query performance analytics

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

Created by [Your Name](https://github.com/yourusername)

Special thanks to:
- [CodeMirror](https://codemirror.net/) for the SQL editor
- [Bootstrap](https://getbootstrap.com/) for the UI framework
- [Font Awesome](https://fontawesome.com/) for icons

## Support

- 🐛 [Report bugs](https://github.com/yourusername/sqlite_dashboard/issues)
- 💡 [Request features](https://github.com/yourusername/sqlite_dashboard/issues)
- 📧 [Email support](mailto:your.email@example.com)

---

Made with ❤️ for the Rails community