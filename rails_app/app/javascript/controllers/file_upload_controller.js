import { Controller } from "@hotwired/stimulus"

// Drag-and-drop PDF picker: highlights the dropzone, shows the chosen file,
// validates it's a PDF, and auto-fills the title from the filename when empty.
export default class extends Controller {
  static targets = ["input", "dropzone", "prompt", "preview", "filename", "filesize", "title"]
  static classes = ["active"]

  open() {
    this.inputTarget.click()
  }

  dragover(e) {
    e.preventDefault()
    this.dropzoneTarget.classList.add(...this.activeClasses)
  }

  dragleave(e) {
    e.preventDefault()
    this.dropzoneTarget.classList.remove(...this.activeClasses)
  }

  drop(e) {
    e.preventDefault()
    this.dropzoneTarget.classList.remove(...this.activeClasses)
    const file = e.dataTransfer.files[0]
    if (!file) return
    this.inputTarget.files = e.dataTransfer.files
    this.show(file)
  }

  change() {
    const file = this.inputTarget.files[0]
    if (file) this.show(file)
  }

  clear(e) {
    e.preventDefault()
    e.stopPropagation()
    this.inputTarget.value = ""
    this.previewTarget.classList.add("hidden")
    this.promptTarget.classList.remove("hidden")
  }

  show(file) {
    if (file.type !== "application/pdf") {
      alert("Please choose a PDF file.")
      this.clear(new Event("clear"))
      return
    }
    this.filenameTarget.textContent = file.name
    this.filesizeTarget.textContent = this.humanSize(file.size)
    this.promptTarget.classList.add("hidden")
    this.previewTarget.classList.remove("hidden")

    if (this.hasTitleTarget && !this.titleTarget.value.trim()) {
      this.titleTarget.value = file.name.replace(/\.pdf$/i, "").replace(/[_-]+/g, " ")
    }
  }

  humanSize(bytes) {
    if (bytes < 1024) return `${bytes} B`
    const units = ["KB", "MB", "GB"]
    let n = bytes / 1024, i = 0
    while (n >= 1024 && i < units.length - 1) { n /= 1024; i++ }
    return `${n.toFixed(1)} ${units[i]}`
  }
}
