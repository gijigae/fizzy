import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "cancel" ]

  submit() {
    this.element.requestSubmit()
  }

  cancel() {
    this.cancelTarget?.click()
  }

  pasteFiles(event) {
    const editor = event.target.closest("house-md")
    if (!editor) return
    
    const files = event.clipboardData?.files
    if (!files?.length) return

    event.preventDefault()

    for (const file of files) {
      const uploadEvent = new CustomEvent("house-md:before-upload", { 
        bubbles: true, 
        detail: { file },
        cancelable: true 
      })
      
      if (editor.dispatchEvent(uploadEvent)) {
        const upload = document.createElement("house-md-upload")
        upload.file = file
        upload.uploadsURL = editor.dataset.uploadsUrl
        editor.appendChild(upload)
      }
    }
  }

  preventAttachment(event) {
    event.preventDefault()
  }

  select(event) {
    event.target.select()
  }

  showPicker(event) {
    if ("showPicker" in HTMLInputElement.prototype) {
      event.target.showPicker()
    }
  }
}
