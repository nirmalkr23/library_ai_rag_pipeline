import { Controller } from "@hotwired/stimulus"

// Toggles between the Sign In and Sign Up panels on the auth landing page.
export default class extends Controller {
  static targets = ["signInTab", "signUpTab", "signInPanel", "signUpPanel", "slider"]
  static values = { active: String }

  connect() {
    this.activeValue === "sign_up" ? this.showSignUp() : this.showSignIn()
  }

  showSignIn() {
    this.signInPanelTarget.classList.remove("hidden")
    this.signUpPanelTarget.classList.add("hidden")
    this.slideTo(0)
    this.activate(this.signInTabTarget, this.signUpTabTarget)
  }

  showSignUp() {
    this.signUpPanelTarget.classList.remove("hidden")
    this.signInPanelTarget.classList.add("hidden")
    this.slideTo(1)
    this.activate(this.signUpTabTarget, this.signInTabTarget)
  }

  slideTo(index) {
    this.sliderTarget.style.transform = `translateX(${index * 100}%)`
  }

  activate(on, off) {
    on.classList.add("text-white")
    on.classList.remove("text-slate-400")
    off.classList.add("text-slate-400")
    off.classList.remove("text-white")
  }
}
