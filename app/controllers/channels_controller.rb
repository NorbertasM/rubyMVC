class ChannelsController < ApplicationController
  before_action :set_channel, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    game_id = params["game_id"]
    language_id = params["language_id"]
    param_tags = params["tag_id"]

    fetch_langauges()

    tags = fetch_all_tags()

    @option_tags = Array.new
    @selected_tags = Array.new

    if param_tags
      tags.each { |tag|
        if param_tags.include?(tag["id"].to_s)
          @selected_tags.append(tag)
        else
          @option_tags.append([tag["name"], tag["id"]])
        end
      }
    else
      tags.each { |tag|
        @option_tags.append([tag["name"], tag["id"]])
      }
    end

    @vip_channels = Array.new
    @channels = Array.new
    
    Channel.all.each { |channel|
      has_tag = @selected_tags.count == 0 || channel.channel_tags.any? { |channel_tag|
        @selected_tags.any? { |selected_tag|
          if selected_tag["forChannel"]
            selected_tag["id"] == channel_tag["tag_id"]
          else
            fetch_games_by_tag_id(selected_tag["id"]).any? { |game|
              channel.channel_game.any?{ |channel_game|
                game["id"] == channel_game["game_id"]
              }
            }
          end
        }
      }

      has_game = game_id.nil? || channel.channel_game.any? { |channel_game|
        channel_game.game_id.to_s == game_id
      }

      if (language_id.nil? || channel.language_id.to_i == language_id.to_i) && has_tag && has_game
      
        status = get_channel_status(channel.channel_status)
        if !status.nil?
          channel.status = status["id"] 
        else
          channel.status = 3
        end

        preview_status = get_channel_status(channel.preview_statuses)

        if !preview_status.nil? && preview_status["id"] == 1
          channel.p_status = 0
          @vip_channels.append(channel)
        else
          if preview_status.nil?
            channel.p_status = 0
          else
            channel.p_status = preview_status["id"]
          end

          @channels.append(channel)
        end
      end
    }

    @vip_channels = @vip_channels.sort_by{|e| -e.status}
    @channels = @channels.sort_by{|e| -e.status}
  end

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

      if response.code === 200
        tag = JSON.parse(response.body)
      end

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
      fetch_new_channel_form_data()
    else
      redirect_to channel_url(current_user.channel)
    end
  end

  def edit
    fetch_langauges()
  end
  
  def create
    tags = channel_params["tags"]
    games = channel_params["games"]

    if !games.nil?
      parsedGames = games.split(',').map(&:to_i)
    end

    logger.debug "-----Games----- #{parsedGames} #{parsedGames.class}"
    @channel = Channel.new(channel_params.except("tags", "games").merge(user_id: current_user.id))
    
    respond_to do |format|
      if @channel.save
        status = ChannelStatus.new(channel_id:@channel.id, status_id: 3)
        status.save

        if !tags.nil?
          tags.each { |tag_id|
            if !tag_id.nil?
              tag = ChannelTag.new(channel_id: @channel.id, tag_id: tag_id.to_i)
              tag.save
            end
          }
        end
        
        if !parsedGames.nil?
          parsedGames.each { |game_id|
            if !game_id.nil?
              game = ChannelGame.new(channel_id: @channel.id, game_id: game_id.to_i)
              game.save
            end
          }
        end

        format.html { redirect_to channel_url(@channel), notice: "Channel was successfully created." }
        format.json { render :show, status: :created, location: @channel }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render :new, json: @channel.errors, status: :unprocessable_entity }
        fetch_new_channel_form_data()
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
        fetch_langauges()
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

    if response.code === 200
      @tags =JSON.parse(response.body)
    end
  end
  
  def fetch_all_tags
    response = HTTParty.get("http://127.0.0.1:10000/tag")
  
    if response.code === 200
      return JSON.parse(response.body)
    end
  end

  def fetch_games_by_tag_id(tag_id)
    response = HTTParty.get("http://127.0.0.1:10000/game?tagId=" + tag_id.to_s)
  
    if response.code === 200
      return JSON.parse(response.body)["games"]
    end
  end


  def fetch_langauges
    @languages = Array.new
    
    response = HTTParty.get("http://127.0.0.1:10000/language")

    if response.code === 200
      JSON.parse(response.body).each { |langauge|
        @languages.append([langauge["name"], langauge["id"]])
      }
    end
  end
  
  def fetch_language_by_id(id) 
    response = HTTParty.get("http://127.0.0.1:10000/language?id=" + id.to_s )

    if response.code === 200
      return JSON.parse(response.body)
    end
  end

  def fetch_channel_status_by_id(id)
    response = HTTParty.get("http://127.0.0.1:10000/status?id=" + id.to_s )

    if response.code === 200
      return JSON.parse(response.body)
    end
  end

  def fetch_new_channel_form_data    
    @games = Array.new

    fetch_langauges()
    fetch_channel_tags()

    if params["gameSearch"].nil?
      response = HTTParty.get("http://127.0.0.1:10000/game")
      if response.code === 200
        @games = JSON.parse(response.body)["games"]
      end
    else
      response = HTTParty.get("http://127.0.0.1:10000/search?by=game&value=" + params["gameSearch"])
      if response.code === 200
        @games = JSON.parse(response.body)
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel
      @channel = Channel.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def channel_params
      params.require(:channel).permit(:title, :description, :stream_link, :preview_url, :user_id, :language_id, :about, :games, :tags => [])
    end
end
