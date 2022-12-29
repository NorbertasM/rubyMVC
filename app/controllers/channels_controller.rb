class ChannelsController < ApplicationController
  before_action :set_channel, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]
  after_action :test, only: [:create]

  # GET /channels or /channels.json
  def index
    game_id = params["game_id"]

    if game_id.nil?
      @channels = Channel.all
    else
      @channels = Array.new
      Channel.all.each { |x|
        x.channel_game.each { |channel_game|
          if channel_game.game_id == game_id.to_i
            @channels.append(x)
          end
        }
      }
    end

  end

  # GET /channels/1 or /channels/1.json
  def show
    @games = Array.new

    @channel.channel_game.all.each { |x|
      response = HTTParty.get("http://127.0.0.1:10000/game?id=" + x["game_id"].to_s)

      game = JSON.parse(response.body)

      @games.append(game)
    }   
  end

  # GET /channels/new
  def new
    @channel = Channel.new
  end

  # GET /channels/1/edit
  def edit
  end
  
  # POST /channels or /channels.json
  def create
    @channel = Channel.new(channel_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @channel.save
        format.html { redirect_to channel_url(@channel), notice: "Channel was successfully created." }
        format.json { render :show, status: :created, location: @channel }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /channels/1 or /channels/1.json
  def update
    respond_to do |format|
      if @channel.update(channel_params)
        format.html { redirect_to channel_url(@channel), notice: "Channel was successfully updated." }
        format.json { render :show, status: :ok, location: @channel }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channels/1 or /channels/1.json
  def destroy
    @channel.destroy

    respond_to do |format|
      format.html { redirect_to channels_url, notice: "Channel was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def correct_user
    if current_user.channel.nil? || current_user.channel.id != params[:id].to_i
      redirect_to channels_path, notice: "Not authorized"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel
      @channel = Channel.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def channel_params
      params.require(:channel).permit(:title, :description, :stream_link, :preview_url, :user_id)
    end
end
