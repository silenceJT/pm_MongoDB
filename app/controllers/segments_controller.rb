class SegmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_email
  before_action :set_segment, only: %i[ show edit update destroy ]

  # GET /segments or /segments.json
  def index
    @segments = Segment.all.order(no: 1)
  end

  # GET /segments/1 or /segments/1.json
  def show
    @papuas = @segment.papuas
    @papuas_other = Papua.not_in(id: @papuas.pluck(:id))
  end

  # GET /segments/new
  def new
    @segment = Segment.new
  end

  # GET /segments/1/edit
  def edit
  end

  # POST /segments or /segments.json
  def create
    @segment = Segment.new(segment_params)

    respond_to do |format|
      if @segment.save
        format.html { redirect_to @segment, notice: "Segment was successfully created." }
        format.json { render :show, status: :created, location: @segment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @segment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /segments/1 or /segments/1.json
  def update
    respond_to do |format|
      if @segment.update(segment_params)
        format.html { redirect_to @segment, notice: "Segment was successfully updated." }
        format.json { render :show, status: :ok, location: @segment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @segment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /segments/1 or /segments/1.json
  def destroy
    @segment.destroy
    respond_to do |format|
      format.html { redirect_to segments_url, notice: "Segment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_segment
      @segment = Segment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def segment_params
      params.require(:segment).permit(:no, :ipa, :cvd, :plain_vs_non_plain, :voicing, :place, :manner, :additional, :extra, :unicode, :notes)
    end
end
