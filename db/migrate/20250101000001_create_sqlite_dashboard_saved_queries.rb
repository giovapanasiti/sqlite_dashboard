# frozen_string_literal: true

class CreateSqliteDashboardSavedQueries < ActiveRecord::Migration[7.0]
  def change
    create_table :dashboard_saved_queries do |t|
      t.string :name, null: false
      t.text :query, null: false
      t.string :database_name
      t.text :description

      t.timestamps
    end

    add_index :dashboard_saved_queries, :name
    add_index :dashboard_saved_queries, :created_at
  end
end
