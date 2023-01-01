import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

document.addEventListener("DOMContentLoaded", function(){
  const item = document.getElementById('tags-container')

  const children = [...item.children]
  children.map(child => {
    child.addEventListener('click', function() {
      const params = new URLSearchParams(window.location.search)
      const allTagIds = [...params.getAll("tag_id[]")]

      params.delete("tag_id[]")

      allTagIds.map(tagId => {
        if (tagId !== child.id) {
          params.append("tag_id[]", tagId)
        }
      })

      window.location.search = params
    })
  })
}, { once: true });

export { application }
