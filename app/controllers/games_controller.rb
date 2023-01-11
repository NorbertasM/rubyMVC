class GamesController < ApplicationController
  def index
    @page = params["page"].to_i
    search = params["value"]

    if search
      @games = doSearch(search)
      @count = nil
      @page = nil
    else

      if @page == 0
        @page = 1
      end
      
      response = HTTParty.get("http://127.0.0.1:10000/game?page=" + (@page - 1).to_s)

      if response.code === 200
        parsed = JSON.parse(response.body)
        @games = parsed["games"]
        @count = parsed["count"]
      end

    end
  end

  def doSearch(value)
    response = HTTParty.get("http://127.0.0.1:10000/search?by=game&value=" + value)

    if response.code === 200
      return JSON.parse(response.body)
    end
  end
end

