import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  
  connect() {    
    let globalSearchTimeout
    const searchBox = document.getElementById("games-search")
    
    if (searchBox) {
      searchBox.addEventListener('keyup',(e) => onSearchKeydown(e))
    }

    getDefaultData()
    
    function onSearchKeydown(e) {
      const value = e.target?.value
    
      if (globalSearchTimeout) {
        clearTimeout(globalSearchTimeout)
      }
    
      if (value?.length > 2) {
        globalSearchTimeout = setTimeout(() => doSearch(value), 1000);
      } else if (value.length === 0) {
        globalSearchTimeout = setTimeout(() => getDefaultData(), 1000);
      }
    }

    function doSearch(searchString) {
      const dropdown = document.getElementById("myDropdown")

      if (dropdown) {
        fetch('http://127.0.0.1:10000/search?by=game&value='+searchString).then((response) => response.json())
        .then((data) => {
          while (dropdown.firstChild) {
            dropdown.removeChild(dropdown.lastChild);
          }

          const currentGames = document.getElementById("games-input")?.value

          if (data) {
            for (var i = 0; i < data.length; i++) {
              if (!currentGames?.includes(data[i].id)) {
                var option = document.createElement("option");
                option.value = data[i].id;
                option.innerText = data[i].name;
                option.classList.add("option-className")
                option.addEventListener('click', (e) => onOptionClick(e))
                dropdown.appendChild(option);
              }
            }
          }
        })
      } 
    }

    function getDefaultData() {
      const dropdown = document.getElementById("myDropdown")

      if (dropdown) {
        fetch('http://127.0.0.1:10000/game?step=10').then((response) => response.json())
        .then((data) => {
          while (dropdown.firstChild) {
            dropdown.removeChild(dropdown.lastChild);
          }
          
          const currentGames = document.getElementById("games-input")?.value

          for (var i = 0; i < data.games.length; i++) {
            if (!currentGames.includes(data.games[i].id)) {
              var option = document.createElement("option");
              option.value = data.games[i].id;
              option.innerText = data.games[i].name;
              option.classList.add("option-className")
              option.addEventListener('click', (e) => onOptionClick(e))
              dropdown.appendChild(option);
            }
          }
        })
      }
    } 

    function onOptionClick(e) {
      const newValue = e.target.value
      onAddGame(newValue, e.target.innerText)

      const gamesInput = document.getElementById("games-input")

      if (gamesInput) {
        const currentValue = gamesInput.value

        gamesInput.value = typeof currentValue === 'string' ?
          currentValue.length === 0 ?
          [e.target.value] :
          [currentValue, newValue] :
          [...currentValue, newValue] 
      }
      const searchInput = document.getElementById("games-search")
      if (searchInput) searchInput.value = ""
      getDefaultData()
    }

    function onAddGame(id, name) {
      const gamesDiv = document.getElementById("games-div")

      if (gamesDiv) {
        const item = document.createElement('span')
        item.id = id
        item.innerText = name + " X"
        item.classList.add("badge", "rounded-pill", "text-bg-primary", "tag-badge", "mx-1")

        item.addEventListener('click', function(e) {
          const gamesInput = document.getElementById("games-input")

          if (gamesInput) {
            const currentValue = gamesInput.value 
            let newValue = currentValue.replace(e.target.id, '')
            newValue = newValue.replace(",,", ',')
            newValue = newValue.replace(", ,", ',')

            if (newValue[0] === ',') {
              newValue = newValue.substring(1)
            }
            if (newValue[newValue.length - 1] === ',') {
              newValue = newValue.substring(0, newValue.length - 1)
            }

            gamesInput.value = newValue

            e.target.remove()
          }
        })

        gamesDiv.appendChild(item)
      }
      
      const dropdown = document.getElementById("myDropdown")

      if (dropdown) {
        [...dropdown.children].map(item => {
          if (item.value == id) item.remove()
        })
      }
    }

  }

  showDropdown() {
    document.getElementById("myDropdown").classList.add("show");
  }

  hideDropdown() {
    window.setTimeout(() => {
      document.getElementById("myDropdown").classList.remove("show");
    }, 100)
  }
}
