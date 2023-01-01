class ChannelTagsController < ApplicationController
  before_action :set_channel_tag, only: %i[ show edit update destroy ]
  
  def new
    @channel_tag = ChannelTag.new

    response = HTTParty.get("http://127.0.0.1:10000/tag?forChannel=true")
    
    if response.code == 200 
      @options = JSON.parse(response.body)
    else
      flash[:alert] = "Error fetching tags <br /> #{response.message}".html_safe
    end
  end

  def create
    tag_ids = channel_tag_params["tags"]

    if !tag_ids.nil?
      tag_ids.each{ |tag_id|
        if !has_tag(tag_id)
          @channel_tag = ChannelTag.new(channel_id: current_user.channel.id, tag_id: tag_id)
          @channel_tag.save
        end
      }
    end

    current_user.channel.channel_tags.each { |channel_tag|
      if tag_ids.nil? || !tag_ids.include?(channel_tag.tag_id.to_s)
        channel_tag.destroy
      end
    }

    redirect_to channel_url(current_user.channel)
  end

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
    def set_channel_tag
      @channel_tag = ChannelTag.find(params[:id])
    end

    def channel_tag_params
      params.require(:channel_tag).permit(:tags => [])
    end
end
