class ChannelStatusesController < ApplicationController
  before_action :set_channel_status, only: %i[ show edit update destroy ]

  def create
    @channel_status = ChannelStatus.new(channel_status_params)

    respond_to do |format|
      if @channel_status.save
        redirect_to channel_url(channel_status_params["channel_id"])
      else
        redirect_to channel_url(channel_status_params["channel_id"])
        flash[:alert] = "Error changing channel status"
      end
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
