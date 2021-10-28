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
    papuas = Papua.all.where(:inv => /#{seg}/)

    papuas = papuas.where(:language_name => /#{params[:language_name]}/i) if params[:language_name].present?
    papuas = papuas.where(:language_family => /#{params[:language_family]}/i) if params[:language_family].present?
    papuas = papuas.where(:iso => /#{params[:iso]}/i) if params[:iso].present?
    papuas = papuas.where(:area => /#{params[:area]}/i) if params[:area].present?
    papuas = papuas.where(:country => /#{params[:country]}/i) if params[:country].present?
    papuas = papuas.where(:region => /#{params[:region]}/i) if params[:region].present?

    if params[:c_size].present?
      case params[:c_compare]
      when ">="
        papuas = papuas.where(:count_of_consonants.gte => params[:c_size])
      when ">"
        papuas = papuas.where(:count_of_consonants.gt => params[:c_size])
      when "="
        papuas = papuas.where(:count_of_consonants => params[:c_size])
      when "<"
        papuas = papuas.where(:count_of_consonants.lt => params[:c_size])
      else
        papuas = papuas.where(:count_of_consonants.lte => params[:c_size])
      end
    end

    if params[:v_size].present?
      case params[:v_compare]
      when ">="
        papuas = papuas.where(:count_of_consonants.gte => params[:v_size])
      when ">"
        papuas = papuas.where(:count_of_consonants.gt => params[:v_size])
      when "="
        papuas = papuas.where(:count_of_consonants => params[:v_size])
      when "<"
        papuas = papuas.where(:count_of_consonants.lt => params[:v_size])
      else
        papuas = papuas.where(:count_of_consonants.lte => params[:v_size])
      end
    end

    if params[:total_size].present?
      case params[:total_compare]
      when ">="
        papuas = papuas.where(:count_of_consonants.gte => params[:total_size])
      when ">"
        papuas = papuas.where(:count_of_consonants.gt => params[:total_size])
      when "="
        papuas = papuas.where(:count_of_consonants => params[:total_size])
      when "<"
        papuas = papuas.where(:count_of_consonants.lt => params[:total_size])
      else
        papuas = papuas.where(:count_of_consonants.lte => params[:total_size])
      end
    end

    #full text search
    if params[:inv].present?
      exclude_array = Array.new()
      include_array = Array.new()
      counts_inc = Hash.new()
      counts_exc = Hash.new()
      combined_inc = Array(1..Papua.all.size)
      combined_exc = Array.new()
      all_no = Array(1..Papua.all.size)
      final_no = Array.new()

      # split inc and exc into 2 arraies
      str_array = params[:inv].split(" ")
      str_array.each do |str_item|
        if str_item.start_with?('-')
          str_item.slice!(0)
          exclude_array.push(str_item)
        else
          include_array.push(str_item)
        end
      end

      # extract no from results
      include_array.each do |inc_item|
        include_no = []
        papuas.each do |papua|
          for p_inv in papua.inv.split("\,") do
            p_inv_striped = p_inv.strip
            if p_inv_striped == inc_item
              include_no.push(papua.no)
            end
          end
        end
        # papuas_inc = papuas.where(:inv => /#{inc_item}/)
        # papuas_inc.each do |p_inc|
        #   include_no.push(p_inc.no)
        # end
        combined_inc = combined_inc & include_no
      end

      exclude_array.each do |exc_item|
        exclude_no = []
        papuas.each do |papua|
          for p_inv in papua.inv.split("\,") do
            p_inv_striped = p_inv.strip
            if p_inv_striped == exc_item
              exclude_no.push(papua.no)
            end
          end
        end
        # papuas_exc = papuas.where(:inv => /#{exc_item}/)
        # papuas_exc.each do |p_exc|
        #   exclude_no.push(p_exc.no)
        # end
        combined_exc = combined_exc | exclude_no
      end

      final_no = combined_inc & (all_no - combined_exc)

      papuas = papuas.in(:no => final_no)

    end

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
      params.require(:segment).permit(:no, :ipa, :sequence, :category, :place)
    end

    def verify_email
      whitelist = ["jessewjt@gmail.com", "j.hajek@unimelb.edu.au", "timothy.brickell@unimelb.edu.au"]
      (redirect_to(root_path) unless whitelist.include?(current_user.email))
    end
end
