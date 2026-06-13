import { Controller } from "@hotwired/stimulus"

// Toggles a password field between hidden and visible, swapping the eye icon.
export default class extends Controller {
  static targets = ["input", "eye", "eyeOff"]

  toggle() {
    const show = this.inputTarget.type === "password"
    this.inputTarget.type = show ? "text" : "password"
    this.eyeTarget.classList.toggle("hidden", show)
    this.eyeOffTarget.classList.toggle("hidden", !show)
  }
}
