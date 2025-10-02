import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["queryInput"]

  execute(event) {
    event.preventDefault()

    const form = event.target
    const formData = new FormData(form)
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content

    fetch(form.action, {
      method: form.method || 'POST',
      body: formData,
      headers: {
        'X-CSRF-Token': csrfToken,
        'Accept': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      console.log("Query response:", data)
      this.displayResults(data)
    })
    .catch(error => {
      console.error("Query error:", error)
      this.displayError(error.message || "An error occurred")
    })
  }

  displayResults(data) {
    const resultsDiv = document.getElementById("query-results")

    if (data.error) {
      this.displayError(data.error)
      return
    }

    if (data.columns && data.columns.length > 0) {
      let html = `
        <div class="table-wrapper">
          <table class="table table-striped table-hover table-bordered">
            <thead class="table-dark">
              <tr>
                ${data.columns.map(col => `<th>${this.escapeHtml(col)}</th>`).join('')}
              </tr>
            </thead>
            <tbody>
              ${data.rows.map(row =>
                `<tr>${row.map(val => `<td>${this.escapeHtml(String(val || ''))}</td>`).join('')}</tr>`
              ).join('')}
            </tbody>
          </table>
        </div>
        <div class="mt-3">
          <small class="text-muted">
            ${data.rows.length} row${data.rows.length !== 1 ? 's' : ''} returned
          </small>
        </div>
      `
      resultsDiv.innerHTML = html
    } else if (data.message) {
      resultsDiv.innerHTML = `
        <div class="success-message">
          <i class="fas fa-check-circle"></i> ${this.escapeHtml(data.message)}
        </div>
      `
    } else {
      resultsDiv.innerHTML = `
        <div class="text-muted text-center py-5">
          <p>No results returned</p>
        </div>
      `
    }
  }

  displayError(error) {
    const resultsDiv = document.getElementById("query-results")
    resultsDiv.innerHTML = `
      <div class="error-message">
        <i class="fas fa-exclamation-circle"></i> <strong>Error:</strong> ${this.escapeHtml(error)}
      </div>
    `
  }

  escapeHtml(text) {
    const div = document.createElement('div')
    div.textContent = text
    return div.innerHTML
  }

  clear() {
    this.queryInputTarget.value = ""
    this.queryInputTarget.focus()
  }
}