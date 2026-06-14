import { Controller } from "@hotwired/stimulus"

// Shows a full-screen "processing" overlay while the upload request runs
// (synchronous perform_now), cycling through the pipeline steps for feedback.
export default class extends Controller {
  static targets = ["overlay", "step"]

  STEPS = [
    "Uploading PDF…",
    "Extracting text from pages…",
    "Splitting into chunks…",
    "Generating embeddings with Gemini…",
    "Storing vectors in the database…",
    "Almost there…"
  ]

  show(event) {
    // Only show if a file is actually attached (let validation errors through otherwise).
    const input = this.element.querySelector('input[type="file"]')
    if (input && input.files.length === 0) return

    this.overlayTarget.classList.remove("hidden")
    this.i = 0
    this.render()
    this.timer = setInterval(() => {
      this.i = Math.min(this.i + 1, this.STEPS.length - 1)
      this.render()
    }, 1800)
  }

  render() {
    if (this.hasStepTarget) this.stepTarget.textContent = this.STEPS[this.i]
  }

  disconnect() {
    if (this.timer) clearInterval(this.timer)
  }
}
