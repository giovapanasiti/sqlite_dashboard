pin "sqlite_dashboard/application"
pin_all_from File.expand_path("../app/javascript/controllers", __dir__), under: "controllers", to: "sqlite_dashboard/controllers"