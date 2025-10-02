import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"

import QueryExecutorController from "controllers/query_executor_controller"
import TableSelectorController from "controllers/table_selector_controller"

window.Stimulus = Application.start()
Stimulus.register("query-executor", QueryExecutorController)
Stimulus.register("table-selector", TableSelectorController)