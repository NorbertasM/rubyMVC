import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  
  connect() {
    const authenticityToken =  this.element.dataset.token
    const currentGames = JSON.parse(this.element.dataset.games)
    const searchBox = document.getElementById("channel-games-search")

    let globalSearchTimeout
    
    if (searchBox) {
      searchBox.addEventListener('keyup',(e) => onSearchKeydown(e))
      searchBox.addEventListener('focus', () => showDropdown())
      searchBox.addEventListener('click', () => showDropdown())
      searchBox.addEventListener('blur', () => hideDropdown())
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
      const dropdown = document.getElementById("games-dropdown")

      if (dropdown) {
        fetch('http://127.0.0.1:10000/search?by=game&value='+searchString).then((response) => response.json())
        .then((data) => {
          while (dropdown.firstChild) {
            dropdown.removeChild(dropdown.lastChild);
          }

          if (data) {
            for (var i = 0; i < data.length; i++) {
              if (!currentGames?.find(({ game_id }) => game_id === data[i].id)) {
                const option = createOption(data[i].id, data[i].name)
                dropdown.appendChild(option);
              }
            }
          }
        })
      } 
    }

    function createOption(value, name) {
      var option = document.createElement("option");
      option.value = value
      option.innerText = name;
      option.classList.add("option-className")
      option.addEventListener('click', (e) => onOptionClick(e))
      return option
    }

    function getDefaultData() {
      const dropdown = document.getElementById("games-dropdown")

      if (dropdown) {
        fetch('http://127.0.0.1:10000/game?step=10').then((response) => response.json())
        .then((data) => {
          while (dropdown.firstChild) {
            dropdown.removeChild(dropdown.lastChild);
          }

          for (var i = 0; i < data.games.length; i++) {
            if (!currentGames?.find(({ game_id }) => game_id === data.games[i].id)) {
              var option = createOption(data.games[i].id, data.games[i].name)
              dropdown.appendChild(option);
            }
          }
        })
      }
    } 

    function onOptionClick(e) {
      onAddGame(e.target.value)

      const searchInput = document.getElementById("channel-games-search")
      if (searchInput) searchInput.value = ""
      getDefaultData()
    }

    function onAddGame(id) {
      let data = { authenticity_token: authenticityToken, game: id }

      fetch("/channel_games", {
        method: "POST",
        headers: {'Content-Type': 'application/json' }, 
        body: JSON.stringify(data)
      }).then(() => {
        window.location.reload()
      });
      
      const dropdown = document.getElementById("games-dropdown")

      if (dropdown) {
        [...dropdown.children].map(item => {
          if (item.value == id) item.remove()
        })
      }
    }
    
    function showDropdown() {
      document.getElementById("games-dropdown").classList.add("show");
    }

    function hideDropdown() {
      window.setTimeout(() => {
        document.getElementById("games-dropdown").classList.remove("show");
      }, 100)
    }
  }
}
