# frozen_string_literal: true

module SqliteDashboard
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
