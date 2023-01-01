class GamesController < ApplicationController
  def index
    response = HTTParty.get("http://127.0.0.1:10000/game")
    @games = JSON.parse(response.body)
  end
end
