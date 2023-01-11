class PreviewStatusesController < ApplicationController
  before_action :set_preview_status, only: %i[ show edit update destroy ]

  def new
    @preview_status = PreviewStatus.new

    @options = [["1 month", 1], ["2 month", 2], ["3 month", 3], ["6 month", 6], ["12 month", 12]]
  end

  def create
    valid_until = DateTime.now.months_since(preview_status_params[:duration].to_i)
    @preview_status = PreviewStatus.new(valid_until: valid_until, channel_id: current_user.channel.id, status_id: 1)

    if @preview_status.save
      redirect_to channel_path(current_user.channel.id)
    else
      render :new, status: :bad_request
    end
  end

  private
    def set_preview_status
      @preview_status = PreviewStatus.find(params[:id])
    end

    def preview_status_params
      params.require(:preview_status).permit(:duration)
    end
end
