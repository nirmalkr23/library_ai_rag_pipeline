import { Controller } from "@hotwired/stimulus"

// Auto-dismisses flash messages after a few seconds; click to dismiss early.
export default class extends Controller {
  connect() {
    this.timeout = setTimeout(() => this.dismiss(), 4000)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  dismiss() {
    this.element.classList.add("opacity-0", "transition", "duration-300")
    setTimeout(() => this.element.remove(), 300)
  }
}
