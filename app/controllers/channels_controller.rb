class ChannelsController < ApplicationController
  before_action :set_channel, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]
  # after_action :test, only: [:create]

  def index
    game_id = params["game_id"]
    language_id = params["language_id"]

    get_langauges()

    if game_id.nil?
      channels = Channel.all
    else
      channels = Array.new
      Channel.all.each { |x|
        x.channel_game.each { |channel_game|
          if channel_game.game_id == game_id.to_i
            channels.append(x)
          end
        }
      }
    end

    @channels = Array.new

    channels.each { |channel|
      if language_id.nil? || channel.language_id.to_i == language_id.to_i
        games = Array.new

        channel.channel_game.each { |channel_game|
          response = HTTParty.get("http://127.0.0.1:10000/game?id=" + channel_game["game_id"].to_s)

          game = JSON.parse(response.body)

          games.append(game)
        }

        channel.language = get_language_by_id(channel["language_id"])

        channel.games =  games
        @channels.append(channel)
      end
    }
  end

  # GET /channels/1 or /channels/1.json
  def show
    @games = Array.new

    @language = get_language_by_id(@channel.language_id)

    @channel.channel_game.all.each { |x|
      response = HTTParty.get("http://127.0.0.1:10000/game?id=" + x["game_id"].to_s)

      game = JSON.parse(response.body)

      @games.append(game)
    }
  end

  def new
    if current_user.channel.nil?
      @channel = Channel.new
      get_langauges()
    else
      redirect_to channel_url(current_user.channel)
    end
  end

  # GET /channels/1/edit
  def edit
    get_langauges()
  end
  
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

  def get_langauges
    @languages = Array.new
    
    response = HTTParty.get("http://127.0.0.1:10000/language")

    JSON.parse(response.body).each { |langauge|
      @languages.append([langauge["name"], langauge["id"]])
     }
  end
  
  def get_language_by_id(id) 
    response = HTTParty.get("http://127.0.0.1:10000/language?id=" + id.to_s )

    return JSON.parse(response.body)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel
      @channel = Channel.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def channel_params
      params.require(:channel).permit(:title, :description, :stream_link, :preview_url, :user_id, :language_id, :about)
    end
end
