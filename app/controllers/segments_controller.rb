class SegmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_email
  before_action :set_segment, only: %i[ show edit update destroy ]

  # GET /segments or /segments.json
  def index
    @segments = Segment.all
    @seg_list = Array.new()
    @papuas = Papua.all
    @papuas.each do |pap|
      pap.consonants.split("\,").each do |p_c|
        unless @seg_list.to_s.include?(p_c)
          @seg_list.push(p_c)
        end
      end
    end
  end

  # GET /segments/1 or /segments/1.json
  def show
    seg = @segment.ipa.to_s
    other = Array.new()
    #@segment.ipa.to_s
    @papuas = Papua.all.where(:inv => /#{seg}/)
    @papuas = @papuas.order(no: 1)
    @papuas.each do |p|
      other.push(p.no)
    end
    @papuas_other = Papua.not_in(:no => other)
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
      params.require(:segment).permit(:no, :ipa, :sequence, :category, :place)
    end

    def verify_email
      whitelist = ["jessewjt@gmail.com", "j.hajek@unimelb.edu.au", "timothy.brickell@unimelb.edu.au"]
      (redirect_to(root_path) unless whitelist.include?(current_user.email))
    end
end
