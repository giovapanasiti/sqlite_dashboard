module SqliteDashboard
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    layout "sqlite_dashboard/application"
  end
end