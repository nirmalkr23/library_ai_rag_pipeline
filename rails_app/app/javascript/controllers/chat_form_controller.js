import { Controller } from "@hotwired/stimulus"

// Chat input box: Enter sends (Shift+Enter = newline), clears after submit.
export default class extends Controller {
  static targets = ["input"]

  submitOnEnter(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      if (this.inputTarget.value.trim()) this.element.requestSubmit()
    }
  }

  reset() {
    this.inputTarget.value = ""
    this.inputTarget.focus()
  }
}
