import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  
  connect() {
    const tags = document.getElementById('tags-container')

    if (tags?.children) {
      [...tags.children].map(child => {
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
    }

    const languageSelect = document.getElementById('language-select')

    if (languageSelect) {
      languageSelect.addEventListener('change', onLanguageSelect)
    }
  
    function onLanguageSelect() {
      const params = new URLSearchParams(window.location.search)
      if (this.value) {
        if (!params.get('language_id')) {
          params.append('language_id', this.value)
        } else {
          params.set('language_id', this.value)
        }
        window.location.search = params
      } else if (params.get('language_id')) {
        params.delete('language_id')
        window.location.search = params
      }
    }

    const tagsSelect = document.getElementById('tags-select')

    if (tagsSelect) {
      tagsSelect.addEventListener('change', onTagSelect)
    }

    function onTagSelect() {
      const params = new URLSearchParams(window.location.search)
      if (this.value) {
        params.append('tag_id[]', this.value)
        window.location.search = params
      }
    }

  }
}
