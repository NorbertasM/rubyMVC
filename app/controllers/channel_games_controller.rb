class ChannelGamesController < ApplicationController
  before_action :set_channel_game, only: %i[ show edit update destroy ]

  # GET /channel_games or /channel_games.json
  def index
    @channel_games = ChannelGame.all
  end

  # GET /channel_games/1 or /channel_games/1.json
  def show
  end

  # GET /channel_games/new
  def new
    @channel_game = ChannelGame.new

    response = HTTParty.get("http://127.0.0.1:10000/game")
    @options = JSON.parse(response.body)
  end

  # GET /channel_games/1/edit
  def edit
  end

  # POST /channel_games or /channel_games.json
  def create
    @channel_game = ChannelGame.new(channel_game_params)

    respond_to do |format|
      if @channel_game.save
        format.html { redirect_to channel_game_url(@channel_game), notice: "Channel game was successfully created." }
        format.json { render :show, status: :created, location: @channel_game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @channel_game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /channel_games/1 or /channel_games/1.json
  def update
    respond_to do |format|
      if @channel_game.update(channel_game_params)
        format.html { redirect_to channel_game_url(@channel_game), notice: "Channel game was successfully updated." }
        format.json { render :show, status: :ok, location: @channel_game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @channel_game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channel_games/1 or /channel_games/1.json
  def destroy
    @channel_game.destroy

    respond_to do |format|
      format.html { redirect_to channel_games_url, notice: "Channel game was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel_game
      @channel_game = ChannelGame.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def channel_game_params
      params.require(:channel_game).permit(:game_id, :channel_id)
    end
end
