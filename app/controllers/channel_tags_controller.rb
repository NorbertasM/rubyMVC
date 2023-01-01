class ChannelTagsController < ApplicationController
  before_action :set_channel_tag, only: %i[ show edit update destroy ]

  # GET /channel_tags or /channel_tags.json
  def index
    @channel_tags = ChannelTag.all
  end

  # GET /channel_tags/1 or /channel_tags/1.json
  def show
  end

  # GET /channel_tags/new
  def new
    @channel_tag = ChannelTag.new

    
    response = HTTParty.get("http://127.0.0.1:10000/tag?forChannel=true")
    @options = JSON.parse(response.body)
  end

  # GET /channel_tags/1/edit
  def edit
  end

  # POST /channel_tags or /channel_tags.json
  def create
    tag_ids = channel_tag_params["tags"]

    tag_ids.each{ |tag_id|
      if !has_tag(tag_id)
        @channel_tag = ChannelTag.new(channel_id: current_user.channel.id, tag_id: tag_id)
        @channel_tag.save
      end
    }

    current_user.channel.channel_tags.each { |channel_tag|
      if !tag_ids.include?(channel_tag.tag_id.to_s)
        channel_tag.destroy
      end
    }

    redirect_to channel_url(current_user.channel)
  end

  # PATCH/PUT /channel_tags/1 or /channel_tags/1.json
  def update
    respond_to do |format|
      if @channel_tag.update(channel_tag_params)
        format.html { redirect_to channel_tag_url(@channel_tag), notice: "Channel tag was successfully updated." }
        format.json { render :show, status: :ok, location: @channel_tag }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @channel_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channel_tags/1 or /channel_tags/1.json
  def destroy
    @channel_tag.destroy

    respond_to do |format|
      format.html { redirect_to channel_tags_url, notice: "Channel tag was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def has_tag(id)
    return !!current_user.channel.channel_tags.find { |each| each.tag_id.to_i == id.to_i }
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel_tag
      @channel_tag = ChannelTag.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def channel_tag_params
      params.require(:channel_tag).permit(:tags => [])
    end
end
