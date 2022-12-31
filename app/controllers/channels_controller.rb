class ChannelsController < ApplicationController
  before_action :set_channel, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    game_id = params["game_id"]
    language_id = params["language_id"]

    fetch_langauges()

    if game_id.nil?
      channels = Channel.all
    else
      channels = Array.new
      Channel.all.each { |channel|
        channel.channel_game.each { |channel_game|
          if channel_game.game_id == game_id.to_i
            channels.append(channel)
          end
        }
      }
    end

    full_channels = Array.new
    
    channels.each { |channel|
      if language_id.nil? || channel.language_id.to_i == language_id.to_i
      
        status = get_channel_status(channel.channel_status)
        if !status.nil?
          channel.status = status["id"] 
        else
          channel.status = 15
        end

        preview_status = get_channel_status(channel.preview_statuses)

        if preview_status.nil?
          channel.p_status = 0
        else
          channel.p_status = preview_status["id"]
        end

        full_channels.append(channel)
      end
    }

    @vip_channels = Array.new
    @channels = Array.new

    full_channels.each { |channel|
      if channel.p_status == 17
        @vip_channels.append(channel)
      else
        @channels.append(channel)
      end
    }

    @vip_channels = @vip_channels.sort_by{|e| -e.status}
    @channels = @channels.sort_by{|e| -e.status}
  end

  # GET /channels/1 or /channels/1.json
  def show
    @games = Array.new
    @tags = Array.new
    @language = fetch_language_by_id(@channel.language_id)
    @status = get_channel_status(@channel.channel_status)

    latest_preview = @channel.preview_statuses.max_by {|e| e.created_at }

    if !latest_preview.nil? && latest_preview["valid_until"].to_date > Date.today
      @preview = get_channel_status(@channel.preview_statuses)
      @preview_until = latest_preview["valid_until"].getlocal().to_formatted_s(:db)
    end

    @channel.channel_tags.all.each { |x|
      response = HTTParty.get("http://127.0.0.1:10000/tag?id=" + x["tag_id"].to_s)

      tag = JSON.parse(response.body)

      @tags.append(tag)
    }

    @channel.channel_game.all.each { |x|
      response = HTTParty.get("http://127.0.0.1:10000/game?id=" + x["game_id"].to_s)

      game = JSON.parse(response.body)

      @games.append(game)
    }
  end

  def new
    if current_user.channel.nil?
      @channel = Channel.new
      fetch_langauges()
      fetch_channel_tags()
    else
      redirect_to channel_url(current_user.channel)
    end
  end

  def edit
    fetch_langauges()
  end
  
  def create
    tags = channel_params["tags"]
    @channel = Channel.new(channel_params.except("tags").merge(user_id: current_user.id))

    respond_to do |format|
      if @channel.save
        status = ChannelStatus.new(channel_id:@channel.id, status_id: 15)
        status.save

        tags.each { |tag_id|
          tag = ChannelTag.new(channel_id: @channel.id, tag_id: tag_id.to_i)
          tag.save
        }

        format.html { redirect_to channel_url(@channel), notice: "Channel was successfully created." }
        format.json { render :show, status: :created, location: @channel }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end


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

  def get_channel_status(channel_status)
    if !channel_status.nil?
      status = channel_status.max_by {|e| e.created_at }

      if !status.nil?
        return fetch_channel_status_by_id(status.status_id)
      end
    end
  end

  def fetch_channel_tags
    response = HTTParty.get("http://127.0.0.1:10000/tag?forChannel=true")

    @tags =JSON.parse(response.body)
  end


  def fetch_langauges
    @languages = Array.new
    
    response = HTTParty.get("http://127.0.0.1:10000/language")

    JSON.parse(response.body).each { |langauge|
      @languages.append([langauge["name"], langauge["id"]])
    }
  end
  
  def fetch_language_by_id(id) 
    response = HTTParty.get("http://127.0.0.1:10000/language?id=" + id.to_s )

    return JSON.parse(response.body)
  end

  def fetch_channel_status_by_id(id)
    response = HTTParty.get("http://127.0.0.1:10000/status?id=" + id.to_s )

    if (response.code === 200)
      return JSON.parse(response.body)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel
      @channel = Channel.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def channel_params
      params.require(:channel).permit(:title, :description, :stream_link, :preview_url, :user_id, :language_id, :about, :tags => [])
    end
end
