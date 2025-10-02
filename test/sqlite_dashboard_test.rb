require "test_helper"

class SqliteDashboardTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::SqliteDashboard::VERSION
  end

  def test_configuration_initialization
    config = SqliteDashboard::Configuration.new
    assert_empty config.db_files
  end

  def test_adding_database_to_configuration
    config = SqliteDashboard::Configuration.new
    config.add_database("Test DB", "/path/to/test.db")

    databases = config.databases
    assert_equal 1, databases.length
    assert_equal "Test DB", databases.first[:name]
    assert_equal "/path/to/test.db", databases.first[:path]
  end

  def test_configuration_block
    SqliteDashboard.configure do |config|
      config.db_files = [{ name: "Test", path: "/test.db" }]
    end

    databases = SqliteDashboard.configuration.databases
    assert_equal 1, databases.length
    assert_equal "Test", databases.first[:name]
  end
end