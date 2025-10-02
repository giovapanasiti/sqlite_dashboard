require_relative "lib/sqlite_dashboard/version"

Gem::Specification.new do |spec|
  spec.name        = "sqlite_dashboard"
  spec.version     = SqliteDashboard::VERSION
  spec.authors     = ["SQLite Dashboard Contributors"]
  spec.email       = ["sqlite-dashboard@example.com"]
  spec.homepage    = "https://github.com/giovapanasiti/sqlite_dashboard"
  spec.summary     = "Beautiful SQLite database browser and query interface for Rails"
  spec.description = <<~DESC
    A feature-rich, mountable Rails engine that provides a beautiful web interface
    for browsing and querying SQLite databases. Includes SQL syntax highlighting,
    pagination, table browsing, and a responsive Bootstrap UI.
  DESC
  spec.license     = "MIT"

  spec.metadata = {
    "homepage_uri"          => spec.homepage,
    "source_code_uri"       => "https://github.com/giovapanasiti/sqlite_dashboard",
    "changelog_uri"         => "https://github.com/giovapanasiti/sqlite_dashboard/blob/main/CHANGELOG.md",
    "bug_tracker_uri"       => "https://github.com/giovapanasiti/sqlite_dashboard/issues",
    "documentation_uri"     => "https://github.com/giovapanasiti/sqlite_dashboard#readme",
    "wiki_uri"              => "https://github.com/giovapanasiti/sqlite_dashboard/wiki",
    "funding_uri"           => "https://github.com/sponsors/sqlite-dashboard",
    "rubygems_mfa_required" => "true"
  }

  spec.required_ruby_version = ">= 3.0.0"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir[
      "{app,config,db,lib}/**/*",
      "LICENSE",
      "Rakefile",
      "README.md",
      "CHANGELOG.md",
      "*.gemspec"
    ].reject { |f| File.directory?(f) }
  end

  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "rails", ">= 7.0.0"
  spec.add_dependency "sqlite3", ">= 1.4"

  # Development dependencies
  spec.add_development_dependency "bundler", ">= 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rubocop", "~> 1.21"
  spec.add_development_dependency "rubocop-rails", "~> 2.0"
  spec.add_development_dependency "rubocop-minitest", "~> 0.15"
  spec.add_development_dependency "yard", "~> 0.9"
end