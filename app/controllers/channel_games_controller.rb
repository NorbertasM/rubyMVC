class ChannelGamesController < ApplicationController
  before_action :set_channel_game, only: %i[ show edit update destroy ]

  def new
    @channel_game = ChannelGame.new

    response = HTTParty.get("http://127.0.0.1:10000/game")

    if response.code == 200 
      @options = JSON.parse(response.body)["games"]
    else
      flash[:alert] = "Error fetching games <br /> #{response.message}".html_safe
    end
  end

  def create
    game_ids = channel_game_params["games"]

    game_ids.each { |game_id|
      if !has_game(game_id)
        @channel_game = ChannelGame.new(channel_id: current_user.channel.id, game_id: game_id)
        @channel_game.save
      end
    }

    current_user.channel.channel_game.each { |channel_game|
      if !game_ids.include?(channel_game.game_id.to_s)
        channel_game.destroy
      end
    }

    redirect_to channel_url( current_user.channel)
  end

  def has_game(id)
    return !!current_user.channel.channel_game.find { |each| each.game_id.to_i == id.to_i }
  end

  private
    def set_channel_game
      @channel_game = ChannelGame.find(params[:id])
    end

    def channel_game_params
      params.require(:channel_game).permit(:games => [])
    end
end
