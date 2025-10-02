require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task default: :test

desc "Run RuboCop"
task :rubocop do
  sh "rubocop"
end

desc "Run tests and RuboCop"
task ci: [:test, :rubocop]

desc "Generate documentation"
task :doc do
  sh "yard doc"
end

desc "Open documentation in browser"
task :doc_open => :doc do
  sh "open doc/index.html"
end

desc "Console with gem loaded"
task :console do
  require "irb"
  require "sqlite_dashboard"
  ARGV.clear
  IRB.start
end

desc "Show gem stats"
task :stats do
  puts "SQLite Dashboard Gem Statistics"
  puts "=" * 40

  # Count lines of code
  ruby_files = Dir["lib/**/*.rb", "app/**/*.rb"]
  total_lines = ruby_files.sum { |file| File.readlines(file).count }
  puts "Ruby files: #{ruby_files.count}"
  puts "Lines of Ruby code: #{total_lines}"

  # Count view files
  view_files = Dir["app/**/*.erb"]
  view_lines = view_files.sum { |file| File.readlines(file).count }
  puts "View files: #{view_files.count}"
  puts "Lines of template code: #{view_lines}"

  # Count CSS/JS
  asset_files = Dir["app/assets/**/*", "app/javascript/**/*"].select { |f| File.file?(f) }
  puts "Asset files: #{asset_files.count}"

  puts "Total files: #{ruby_files.count + view_files.count + asset_files.count}"
end