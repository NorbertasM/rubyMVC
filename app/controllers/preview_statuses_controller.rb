class PreviewStatusesController < ApplicationController
  before_action :set_preview_status, only: %i[ show edit update destroy ]

  # GET /preview_statuses or /preview_statuses.json
  def index
    @preview_statuses = PreviewStatus.all
  end

  # GET /preview_statuses/1 or /preview_statuses/1.json
  def show
  end

  # GET /preview_statuses/new
  def new
    @preview_status = PreviewStatus.new

    @options = [["1 month", 1], ["2 month", 2], ["3 month", 3], ["6 month", 6], ["12 month", 12]]
  end

  # GET /preview_statuses/1/edit
  def edit
  end

  # POST /preview_statuses or /preview_statuses.json
  def create
    valid_until = DateTime.now.months_since(preview_status_params[:duration].to_i)
    @preview_status = PreviewStatus.new(valid_until: valid_until, channel_id: current_user.channel.id, status_id: 17)

    if @preview_status.save
      redirect_to channel_path(current_user.channel.id)
    else
      render :new, status: :bad_request
    end
  end

  # PATCH/PUT /preview_statuses/1 or /preview_statuses/1.json
  def update
    respond_to do |format|
      if @preview_status.update(preview_status_params)
        format.html { redirect_to preview_status_url(@preview_status), notice: "Preview status was successfully updated." }
        format.json { render :show, status: :ok, location: @preview_status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @preview_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /preview_statuses/1 or /preview_statuses/1.json
  def destroy
    @preview_status.destroy

    respond_to do |format|
      format.html { redirect_to preview_statuses_url, notice: "Preview status was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_preview_status
      @preview_status = PreviewStatus.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def preview_status_params
      params.require(:preview_status).permit(:duration)
    end
end
