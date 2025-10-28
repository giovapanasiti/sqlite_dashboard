# frozen_string_literal: true

module SqliteDashboard
  class SavedQuery < ApplicationRecord
    self.table_name = "dashboard_saved_queries"

    validates :name, presence: true, uniqueness: true
    validates :query, presence: true
    validates :description, presence: true

    scope :recent, -> { order(created_at: :desc) }
    scope :for_database, ->(database_name) { where(database_name: database_name) }
  end
end
