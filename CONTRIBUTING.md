# Contributing to SQLite Dashboard

Thank you for considering contributing to SQLite Dashboard! This document outlines the process for contributing to this project.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/<your-username>/sqlite_dashboard.git`
3. Install dependencies: `bin/setup`
4. Create a feature branch: `git checkout -b feature/amazing-feature`

## Development Setup

```bash
# Install dependencies
bin/setup

# Run tests
bundle exec rake test

# Run RuboCop
bundle exec rubocop

# Run all checks
bundle exec rake ci

# Start a console
bin/console
```

## Running Tests

We use Minitest for testing. Run the test suite with:

```bash
bundle exec rake test
```

## Code Style

We use RuboCop for code style enforcement. Before submitting a PR, ensure your code passes:

```bash
bundle exec rubocop
```

You can auto-fix most issues with:

```bash
bundle exec rubocop -a
```

## Submitting Changes

1. Write tests for your changes
2. Ensure all tests pass: `bundle exec rake test`
3. Ensure RuboCop passes: `bundle exec rubocop`
4. Update CHANGELOG.md with your changes
5. Commit your changes with a descriptive message
6. Push to your fork: `git push origin feature/amazing-feature`
7. Open a Pull Request

## Pull Request Guidelines

- Include a clear description of the changes
- Reference any related issues
- Include tests for new functionality
- Update documentation as needed
- Ensure CI passes

## Release Process

For maintainers only:

1. Update version in `lib/sqlite_dashboard/version.rb`
2. Update CHANGELOG.md
3. Commit changes: `git commit -m "Release vX.Y.Z"`
4. Create tag: `git tag vX.Y.Z`
5. Push: `git push origin main --tags`
6. Build gem: `gem build sqlite_dashboard.gemspec`
7. Push to RubyGems: `gem push sqlite_dashboard-X.Y.Z.gem`

## Reporting Issues

Please use the GitHub issue tracker to report bugs or request features. Include:

- Ruby version
- Rails version
- SQLite Dashboard version
- Steps to reproduce (for bugs)
- Expected vs actual behavior

## Feature Requests

We welcome feature requests! Please:

- Check existing issues first
- Provide a clear use case
- Consider submitting a PR if you can implement it

## Questions?

Feel free to open an issue for questions or reach out to the maintainers.

Thank you for contributing! 🎉