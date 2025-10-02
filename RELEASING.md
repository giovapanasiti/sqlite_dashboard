# Releasing SQLite Dashboard

This document outlines the process for releasing a new version of the SQLite Dashboard gem.

## Pre-Release Checklist

Before releasing a new version:

- [ ] All tests pass: `bundle exec rake test`
- [ ] RuboCop passes: `bundle exec rubocop`
- [ ] CHANGELOG.md is updated with new features/fixes
- [ ] Version number is updated in `lib/sqlite_dashboard/version.rb`
- [ ] README.md is up to date
- [ ] All security vulnerabilities are addressed

## Version Numbering

SQLite Dashboard follows [Semantic Versioning](https://semver.org/):

- **MAJOR**: Incompatible API changes
- **MINOR**: New functionality (backwards-compatible)
- **PATCH**: Bug fixes (backwards-compatible)

## Release Steps

### 1. Update Version

Edit `lib/sqlite_dashboard/version.rb`:

```ruby
module SqliteDashboard
  VERSION = "1.0.1"  # Update this
end
```

### 2. Update CHANGELOG

Add new section to `CHANGELOG.md`:

```markdown
## [1.0.1] - 2025-01-XX

### Added
- New feature descriptions

### Changed
- Changed feature descriptions

### Fixed
- Bug fix descriptions
```

### 3. Run Tests

```bash
bundle exec rake ci
```

### 4. Commit Changes

```bash
git add .
git commit -m "Release v1.0.1"
```

### 5. Create Git Tag

```bash
git tag v1.0.1
```

### 6. Push to GitHub

```bash
git push origin main
git push origin v1.0.1
```

### 7. Build Gem

```bash
gem build sqlite_dashboard.gemspec
```

### 8. Test Gem Locally (Optional)

```bash
gem install ./sqlite_dashboard-1.0.1.gem
```

### 9. Push to RubyGems

```bash
gem push sqlite_dashboard-1.0.1.gem
```

### 10. Create GitHub Release

1. Go to GitHub releases page
2. Click "Create a new release"
3. Select the tag you created
4. Use version number as title (e.g., "v1.0.1")
5. Copy relevant CHANGELOG entries as description
6. Attach the .gem file
7. Publish release

## Post-Release

- [ ] Verify gem is available on RubyGems
- [ ] Test installation: `gem install sqlite_dashboard`
- [ ] Update any dependent projects
- [ ] Announce on social media/forums if significant release

## Emergency Release

For critical security fixes:

1. Create hotfix branch from latest release tag
2. Apply minimal fix
3. Follow release process with patch version bump
4. Release immediately

## Rollback

If issues are discovered after release:

1. `gem yank sqlite_dashboard -v VERSION` (removes from RubyGems)
2. Fix issues
3. Release new version

## Automation

Consider setting up automated releases with GitHub Actions for future versions.