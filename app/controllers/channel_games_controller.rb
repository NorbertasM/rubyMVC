class ChannelGamesController < ApplicationController
  before_action :set_channel_game, only: %i[ show edit update destroy ]

  def new
    @channel_game = ChannelGame.new

    response = HTTParty.get("http://127.0.0.1:10000/game")
    
    @games = Array.new

    current_games = current_user.channel.channel_game

    if !current_user.channel.channel_game.nil?
      current_user.channel.channel_game.each { |channel_game|
        game = fetch_game_by_id(channel_game["game_id"])
        game["channel_game_id"] = channel_game["id"]
        @games.append(game)
      }
    end

    if response.code == 200 
      @options = JSON.parse(response.body)["games"]
    else
      flash[:alert] = "Error fetching games <br /> #{response.message}".html_safe
    end
  end

  def index

  end

  def create
    @channel_game = ChannelGame.new(channel_id: current_user.channel.id, game_id: channel_game_params["game"])
    @channel_game.save
  end

  def has_game(id)
    return !!current_user.channel.channel_game.find { |each| each.game_id.to_i == id.to_i }
  end

  def redd
    redirect_to  new_channel_game_path
  end

  def destroy
    @channel_game.destroy

    redirect_to  new_channel_game_path
  end
  
  def fetch_game_by_id(id)
    response = HTTParty.get("http://127.0.0.1:10000/game?id=" + id.to_s)
  
    if response.code === 200
      return JSON.parse(response.body)
    end
  end

  private
    def set_channel_game
      @channel_game = ChannelGame.find(params[:id])
    end

    def channel_game_params
      params.permit(:game)
    end
end
