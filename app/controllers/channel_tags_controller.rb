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
  end

  # GET /channel_tags/1/edit
  def edit
  end

  # POST /channel_tags or /channel_tags.json
  def create
    @channel_tag = ChannelTag.new(channel_tag_params)

    respond_to do |format|
      if @channel_tag.save
        format.html { redirect_to channel_tag_url(@channel_tag), notice: "Channel tag was successfully created." }
        format.json { render :show, status: :created, location: @channel_tag }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @channel_tag.errors, status: :unprocessable_entity }
      end
    end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel_tag
      @channel_tag = ChannelTag.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def channel_tag_params
      params.require(:channel_tag).permit(:channel_id, :tag_id)
    end
end
