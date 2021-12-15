class SegmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_email
  before_action :set_segment, only: %i[ show edit update destroy ]

  # GET /segments or /segments.json
  def index
    @segments = Segment.all.order(no: 1)

    # get all segments from languages' inventories
    # @seg_list = Array.new()
    # @papuas = Papua.all
    # @papuas.each do |pap|
    #   pap.consonants.split("\,").each do |p_c|
    #     unless @seg_list.to_s.include?(p_c)
    #       @seg_list.push(p_c)
    #     end
    #   end
    # end

    # total number of languages which have that particular segment
    # @segments.each do |seg|
    #   include_seg_no = 0
    #   Papua.each do |pap|
    #     for p_inv in pap.inv.split("\,") do
    #       p_inv_striped = p_inv.strip
    #       if p_inv_striped === seg.ipa.to_s
    #          include_seg_no = include_seg_no + 1
    #       end
    #     end
    #   end
    #   seg.number = include_seg_no
    #   seg.save
    # end

  end

  # GET /segments/1 or /segments/1.json
  def show
    seg = @segment.ipa.to_s
    other = Array.new()
    include_seg_no = []
    #papuas = Papua.all.where(:inv => /#{seg}/) 模糊搜索
    Papua.each do |papua|
      for p_inv in papua.inv.split("\,") do
        p_inv_striped = p_inv.strip
        if p_inv_striped === seg
          include_seg_no.push(papua.no)
        end
      end
    end

    @segment.number = include_seg_no.size
    @segment.save
    papuas = Papua.in(:no => include_seg_no)
    papuas = papuas.search(params[:language_name], params[:language_family], params[:iso], params[:area], 
      params[:country], params[:region], params[:c_size], params[:c_compare], params[:v_size], 
      params[:v_compare], params[:total_size], params[:total_compare], params[:inv])

    @papuas = papuas.order(no: 1)
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
      params.require(:segment).permit(:no, :ipa, :cvd, :plain_vs_non_plain, :voicing, :place, :manner, :additional, :extra, :unicode, :notes)
    end

    def verify_email
      whitelist = ["jessewjt@gmail.com", "j.hajek@unimelb.edu.au", "timothy.brickell@unimelb.edu.au"]
      (redirect_to(root_path) unless whitelist.include?(current_user.email))
    end
end
