class GamesController < ApplicationController
  def index
    @page = params["page"].to_i

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
