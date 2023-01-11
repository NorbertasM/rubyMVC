import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  
  connect() {
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
  }

  nextPage() {
    const params = new URLSearchParams(window.location.search)
    const pagesCount = Math.floor(this.element.dataset.count / 20)
    const currentPage = params.get('page')

    if (currentPage) {
      if (+currentPage < pagesCount - 1) {
        params.set('page', +currentPage + 1)
        window.location.search = params
      }
    } else {
      params.set('page', 2)
      window.location.search = params
    }
  }
  
  previousPage() {
    const params = new URLSearchParams(window.location.search)
  
    const currentPage = params.get('page')
    if (currentPage && +currentPage > 1) {
      params.set('page', +currentPage)
      window.location.search = params
    }
  }

  onPageSelect(e) {
    const params = new URLSearchParams(window.location.search)
    const currentPage = params.get('page')

    if (+currentPage !== +e.target.id) {
      params.set('page', +e.target.id)
      window.location.search = params
    }
  }
}
