import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "queryInput",
    "queryName",
    "queryDescription",
    "databaseSelector",
    "list",
    "saveError"
  ]

  connect() {
    console.log("SavedQueries controller connected")
    this.loadSavedQueries()
    this.initializeCodeMirror()
  }

  initializeCodeMirror() {
    if (typeof CodeMirror !== 'undefined' && this.hasQueryInputTarget) {
      this.editor = CodeMirror.fromTextArea(this.queryInputTarget, {
        mode: 'text/x-sql',
        theme: 'default',
        lineNumbers: true,
        lineWrapping: true,
        autoCloseBrackets: true,
        matchBrackets: true,
        indentWithTabs: true,
        smartIndent: true,
        extraKeys: {
          "Ctrl-Enter": () => this.execute(),
          "Cmd-Enter": () => this.execute(),
          "Ctrl-Space": "autocomplete"
        }
      })
    }
  }

  async loadSavedQueries() {
    try {
      const response = await fetch('/sqlite_dashboard/saved_queries')
      const queries = await response.json()
      this.renderSavedQueries(queries)
    } catch (error) {
      console.error('Error loading saved queries:', error)
      if (this.hasListTarget) {
        this.listTarget.innerHTML = `
          <div class="text-danger small text-center py-3">
            <i class="fas fa-exclamation-triangle"></i> Error loading queries
          </div>
        `
      }
    }
  }

  renderSavedQueries(queries) {
    if (!this.hasListTarget) return

    if (queries.length === 0) {
      this.listTarget.innerHTML = `
        <div class="text-muted small text-center py-3">
          No saved queries
        </div>
      `
      return
    }

    const html = queries.map(query => `
      <div class="saved-query-item" data-query-id="${query.id}">
        <div class="d-flex justify-content-between align-items-start">
          <div class="flex-grow-1" style="cursor: pointer;" data-action="click->saved-queries#loadQuery" data-query='${JSON.stringify(query)}'>
            <div class="fw-bold small">${this.escapeHtml(query.name)}</div>
            ${query.description ? `<div class="text-muted" style="font-size: 0.75rem;">${this.escapeHtml(query.description)}</div>` : ''}
            ${query.database_name ? `<div class="text-info" style="font-size: 0.7rem;"><i class="fas fa-database"></i> ${this.escapeHtml(query.database_name)}</div>` : ''}
          </div>
          <button class="btn btn-sm btn-link text-danger p-0" data-action="click->saved-queries#deleteQuery" data-query-id="${query.id}">
            <i class="fas fa-trash"></i>
          </button>
        </div>
      </div>
    `).join('')

    this.listTarget.innerHTML = html
  }

  escapeHtml(text) {
    const div = document.createElement('div')
    div.textContent = text
    return div.innerHTML
  }

  async execute() {
    const databaseId = this.databaseSelectorTarget.value
    if (!databaseId) {
      alert('Please select a database first')
      return
    }

    const query = this.editor ? this.editor.getValue() : this.queryInputTarget.value
    if (!query.trim()) {
      alert('Please enter a query')
      return
    }

    try {
      const response = await fetch(`/sqlite_dashboard/databases/${databaseId}/execute_query`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({ query })
      })

      const data = await response.json()

      if (data.error) {
        this.renderError(data.error)
      } else {
        this.renderResults(data, query, databaseId)
      }
    } catch (error) {
      console.error('Error executing query:', error)
      this.renderError(error.message)
    }
  }

  renderResults(data, query, databaseId) {
    const resultsContainer = document.getElementById('worksheet-results')

    if (data.message) {
      resultsContainer.innerHTML = `
        <div class="alert alert-success">
          <i class="fas fa-check-circle"></i> ${data.message}
        </div>
      `
      return
    }

    const { columns, rows } = data

    let html = `
      <div class="results-header">
        <h6>Query Results</h6>
        <div class="text-muted small">${rows.length} row(s) returned</div>
      </div>
      <div class="table-responsive">
        <table class="table table-striped table-hover">
          <thead>
            <tr>
              ${columns.map(col => `<th>${this.escapeHtml(col)}</th>`).join('')}
            </tr>
          </thead>
          <tbody>
            ${rows.map(row => `
              <tr>
                ${row.map(cell => `<td>${cell !== null ? this.escapeHtml(String(cell)) : '<span class="text-muted">NULL</span>'}</td>`).join('')}
              </tr>
            `).join('')}
          </tbody>
        </table>
      </div>
    `

    resultsContainer.innerHTML = html
  }

  renderError(error) {
    const resultsContainer = document.getElementById('worksheet-results')
    resultsContainer.innerHTML = `
      <div class="alert alert-danger">
        <i class="fas fa-exclamation-circle"></i> <strong>Error:</strong> ${this.escapeHtml(error)}
      </div>
    `
  }

  clear() {
    if (this.editor) {
      this.editor.setValue('')
    } else {
      this.queryInputTarget.value = ''
    }
    document.getElementById('worksheet-results').innerHTML = `
      <div class="text-muted text-center py-5">
        <i class="fas fa-database fa-3x mb-3"></i>
        <p>Select a database and execute a query to see results</p>
      </div>
    `
  }

  async saveQuery() {
    const name = this.queryNameTarget.value.trim()
    const description = this.queryDescriptionTarget.value.trim()
    const query = this.editor ? this.editor.getValue() : this.queryInputTarget.value
    const databaseId = this.databaseSelectorTarget.value

    // Get database name from selector
    const databaseName = databaseId ?
      this.databaseSelectorTarget.options[this.databaseSelectorTarget.selectedIndex].text :
      null

    if (!name) {
      this.showSaveError('Query name is required')
      return
    }

    if (!query.trim()) {
      this.showSaveError('Query cannot be empty')
      return
    }

    try {
      const response = await fetch('/sqlite_dashboard/saved_queries', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({
          saved_query: {
            name,
            description,
            query,
            database_name: databaseName
          }
        })
      })

      const data = await response.json()

      if (response.ok) {
        // Close modal
        const modal = bootstrap.Modal.getInstance(document.getElementById('saveQueryModal'))
        modal.hide()

        // Clear form
        this.queryNameTarget.value = ''
        this.queryDescriptionTarget.value = ''
        this.hideSaveError()

        // Reload saved queries
        await this.loadSavedQueries()

        // Show success message
        alert('Query saved successfully!')
      } else {
        this.showSaveError(data.error || 'Failed to save query')
      }
    } catch (error) {
      console.error('Error saving query:', error)
      this.showSaveError(error.message)
    }
  }

  showSaveError(message) {
    if (this.hasSaveErrorTarget) {
      this.saveErrorTarget.textContent = message
      this.saveErrorTarget.classList.remove('d-none')
    }
  }

  hideSaveError() {
    if (this.hasSaveErrorTarget) {
      this.saveErrorTarget.classList.add('d-none')
    }
  }

  loadQuery(event) {
    const queryData = JSON.parse(event.currentTarget.dataset.query)

    if (this.editor) {
      this.editor.setValue(queryData.query)
    } else {
      this.queryInputTarget.value = queryData.query
    }

    // If database_name is present, try to select it
    if (queryData.database_name && this.hasDatabaseSelectorTarget) {
      const option = Array.from(this.databaseSelectorTarget.options)
        .find(opt => opt.text === queryData.database_name)
      if (option) {
        this.databaseSelectorTarget.value = option.value
      }
    }
  }

  async deleteQuery(event) {
    event.stopPropagation()
    const queryId = event.currentTarget.dataset.queryId

    if (!confirm('Are you sure you want to delete this saved query?')) {
      return
    }

    try {
      const response = await fetch(`/sqlite_dashboard/saved_queries/${queryId}`, {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        }
      })

      if (response.ok) {
        await this.loadSavedQueries()
      } else {
        const data = await response.json()
        alert(data.error || 'Failed to delete query')
      }
    } catch (error) {
      console.error('Error deleting query:', error)
      alert('Failed to delete query')
    }
  }

  refresh() {
    this.loadSavedQueries()
  }

  async exportCSV() {
    const databaseId = this.databaseSelectorTarget.value
    if (!databaseId) {
      alert('Please select a database first')
      return
    }

    const query = this.editor ? this.editor.getValue() : this.queryInputTarget.value
    if (!query.trim()) {
      alert('Please enter a query')
      return
    }

    // For CSV export, we'll make a form submission since we need to download a file
    const form = document.createElement('form')
    form.method = 'POST'
    form.action = `/sqlite_dashboard/databases/${databaseId}/export_csv`

    const csrfToken = document.querySelector('[name="csrf-token"]').content
    form.innerHTML = `
      <input type="hidden" name="authenticity_token" value="${csrfToken}">
      <input type="hidden" name="query" value="${this.escapeHtml(query)}">
      <input type="hidden" name="include_headers" value="true">
    `

    document.body.appendChild(form)
    form.submit()
    document.body.removeChild(form)
  }

  async exportJSON() {
    const databaseId = this.databaseSelectorTarget.value
    if (!databaseId) {
      alert('Please select a database first')
      return
    }

    const query = this.editor ? this.editor.getValue() : this.queryInputTarget.value
    if (!query.trim()) {
      alert('Please enter a query')
      return
    }

    // For JSON export, we'll make a form submission since we need to download a file
    const form = document.createElement('form')
    form.method = 'POST'
    form.action = `/sqlite_dashboard/databases/${databaseId}/export_json`

    const csrfToken = document.querySelector('[name="csrf-token"]').content
    form.innerHTML = `
      <input type="hidden" name="authenticity_token" value="${csrfToken}">
      <input type="hidden" name="query" value="${this.escapeHtml(query)}">
      <input type="hidden" name="format" value="array">
      <input type="hidden" name="pretty_print" value="true">
    `

    document.body.appendChild(form)
    form.submit()
    document.body.removeChild(form)
  }
}
