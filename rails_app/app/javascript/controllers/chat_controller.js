import { Controller } from "@hotwired/stimulus"

// Manages the chat message list: shows the user's question + a typing
// indicator immediately on submit, and keeps the view scrolled to the latest.
export default class extends Controller {
  static targets = ["messages", "empty", "input"]

  connect() {
    this.scrollToBottom()
    if (this.hasMessagesTarget) {
      this.observer = new MutationObserver(() => this.scrollToBottom())
      this.observer.observe(this.messagesTarget, { childList: true })
    }
  }

  disconnect() {
    this.observer?.disconnect()
  }

  thinking() {
    const input = this.element.querySelector('[data-chat-form-target="input"]')
    const q = input?.value.trim()
    if (!q) return

    if (this.hasEmptyTarget) this.emptyTarget.remove()

    this.messagesTarget.insertAdjacentHTML("beforeend", `
      <div id="thinking" class="space-y-3">
        <div class="flex justify-end">
          <div class="max-w-[85%] rounded-2xl rounded-br-sm bg-indigo-500 px-3.5 py-2.5 text-sm text-white">${this.escape(q)}</div>
        </div>
        <div class="flex justify-start">
          <div class="rounded-2xl rounded-bl-sm bg-slate-800/80 ring-1 ring-white/10 px-4 py-3">
            <span class="flex gap-1">
              <span class="h-2 w-2 rounded-full bg-slate-400 animate-bounce" style="animation-delay:0ms"></span>
              <span class="h-2 w-2 rounded-full bg-slate-400 animate-bounce" style="animation-delay:150ms"></span>
              <span class="h-2 w-2 rounded-full bg-slate-400 animate-bounce" style="animation-delay:300ms"></span>
            </span>
          </div>
        </div>
      </div>
    `)
    this.scrollToBottom()
  }

  scrollToBottom() {
    if (this.hasMessagesTarget) {
      requestAnimationFrame(() => { this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight })
    }
  }

  escape(str) {
    const div = document.createElement("div")
    div.textContent = str
    return div.innerHTML
  }
}
