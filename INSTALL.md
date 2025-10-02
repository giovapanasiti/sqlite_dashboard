# Installation Instructions

## Quick Start

### 1. Add to Gemfile

```ruby
gem 'sqlite_dashboard'
```

### 2. Bundle Install

```bash
bundle install
```

### 3. Run Generator

```bash
rails generate sqlite_dashboard:install
```

This will:
- Create `config/initializers/sqlite_dashboard.rb`
- Add the mount point to `config/routes.rb`
- Display setup instructions

### 4. Configure Databases

Edit `config/initializers/sqlite_dashboard.rb` and update the database paths:

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
end
```

### 5. Start Rails Server

```bash
rails server
```

### 6. Visit Dashboard

Open your browser to: `http://localhost:3000/sqlite_dashboard`

## Manual Installation

If you prefer not to use the generator:

### 1. Add Route

In `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  mount SqliteDashboard::Engine => "/sqlite_dashboard"

  # Your other routes...
end
```

### 2. Create Initializer

Create `config/initializers/sqlite_dashboard.rb`:

```ruby
SqliteDashboard.configure do |config|
  config.db_files = [
    {
      name: "My Database",
      path: "/path/to/your/database.sqlite3"
    }
  ]
end
```

## Production Setup

⚠️ **Important**: Never expose SQLite Dashboard in production without authentication!

### Option 1: Devise Authentication

```ruby
# config/routes.rb
authenticate :user, ->(user) { user.admin? } do
  mount SqliteDashboard::Engine => "/sqlite_dashboard"
end
```

### Option 2: HTTP Basic Auth

```ruby
# config/initializers/sqlite_dashboard.rb
if Rails.env.production?
  SqliteDashboard::Engine.middleware.use Rack::Auth::Basic do |username, password|
    username == ENV['DASHBOARD_USER'] && password == ENV['DASHBOARD_PASS']
  end
end
```

### Option 3: Environment Restriction

```ruby
# config/routes.rb
unless Rails.env.production?
  mount SqliteDashboard::Engine => "/sqlite_dashboard"
end
```

## Troubleshooting

### Database Not Found

Ensure your database paths are correct:

```ruby
# Check if file exists
File.exist?(Rails.root.join("storage", "development.sqlite3"))
```

### Permission Errors

Ensure Rails can read your SQLite files:

```bash
ls -la storage/
# Should show readable permissions
```

### Asset Issues

If styles/JavaScript don't load, ensure your Rails app supports importmaps:

```ruby
# Gemfile
gem "importmap-rails"
```

### Rails Version Issues

SQLite Dashboard requires Rails 7.0+. For older Rails versions:

```ruby
# Use an older version
gem 'sqlite_dashboard', '~> 0.9.0'
```

## Development Setup

For gem development:

```bash
git clone https://github.com/sqlite-dashboard/sqlite_dashboard.git
cd sqlite_dashboard
bin/setup
bundle exec rake test
```

## Uninstalling

1. Remove from Gemfile: `gem 'sqlite_dashboard'`
2. Remove route from `config/routes.rb`
3. Delete `config/initializers/sqlite_dashboard.rb`
4. Run: `bundle install`

## Getting Help

- 📖 [Documentation](https://github.com/sqlite-dashboard/sqlite_dashboard#readme)
- 🐛 [Report Issues](https://github.com/sqlite-dashboard/sqlite_dashboard/issues)
- 💬 [Discussions](https://github.com/sqlite-dashboard/sqlite_dashboard/discussions)