class ChannelStatusesController < ApplicationController
  before_action :set_channel_status, only: %i[ show edit update destroy ]

  # GET /channel_statuses or /channel_statuses.json
  def index
    @channel_statuses = ChannelStatus.all
  end

  # GET /channel_statuses/1 or /channel_statuses/1.json
  def show
  end

  # GET /channel_statuses/new
  def new
    @channel_status = ChannelStatus.new
  end

  # GET /channel_statuses/1/edit
  def edit
  end

  # POST /channel_statuses or /channel_statuses.json
  def create
    @channel_status = ChannelStatus.new(channel_status_params)
    
    respond_to do |format|
      if @channel_status.save
        redirect_to channel_url(channel_status_params["channel_id"])
      end
    end
  end

  # PATCH/PUT /channel_statuses/1 or /channel_statuses/1.json
  def update
    respond_to do |format|
      if @channel_status.update(channel_status_params)
        format.html { redirect_to channel_status_url(@channel_status), notice: "Channel status was successfully updated." }
        format.json { render :show, status: :ok, location: @channel_status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @channel_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channel_statuses/1 or /channel_statuses/1.json
  def destroy
    @channel_status.destroy

    respond_to do |format|
      format.html { redirect_to channel_statuses_url, notice: "Channel status was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel_status
      @channel_status = ChannelStatus.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def channel_status_params
      params.permit(:channel_id, :status_id)
    end
end
