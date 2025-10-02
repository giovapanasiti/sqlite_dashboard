import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tableItem"]

  selectTable(event) {
    const tableName = event.currentTarget.dataset.tableName

    // Remove active class from all items
    this.tableItemTargets.forEach(item => {
      item.classList.remove("active")
    })

    // Add active class to clicked item
    event.currentTarget.classList.add("active")

    // Update query input with SELECT statement for this table
    const queryInput = document.getElementById("query")
    if (queryInput) {
      queryInput.value = `SELECT * FROM ${tableName} LIMIT 100;`

      // Trigger the query execution using Turbo
      const form = queryInput.closest("form")
      if (form) {
        // Create a submit button click to ensure proper Turbo form submission
        const submitButton = form.querySelector('button[type="submit"]')
        if (submitButton) {
          submitButton.click()
        } else {
          form.requestSubmit()
        }
      }
    }
  }
}