class PapuasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_papua, only: %i[ show edit update destroy ]
  before_action :verify_email
  #before_action :sync, only: %i[ index show edit ]
  #after_action :sync, only: %i[ update destroy ]
  after_action :sync_result, only: %i[ create ]

  # GET /papuas or /papuas.json
  def index
    papua_all = Papua.all
    @papuas = papua_all.search(params).order(no: 1)

    @papuas_results = @papuas
    @papuas_all_size = papua_all.size
    
    @papuas_other = papua_all.not_in(id: @papuas.pluck(:id))

    # must at the end
    respond_to do |format|
        format.html { }
        format.json { render json: @papuas }
        format.js { render :layout => false }
        format.csv { send_data @papuas.to_csv }
        format.xls
    end

    segments_count = @papuas_results.pluck(:count_of_segments).sum
    consonants_count = @papuas_results.pluck(:count_of_consonants).sum
    vowels_count = @papuas_results.pluck(:count_of_vowels).sum

    @avg_s = @papuas_results.length > 0 ? (segments_count/@papuas_results.length).round(2) : 0
    @avg_c = @papuas_results.length > 0 ? (consonants_count/@papuas_results.length).round(2) : 0
    @avg_v = @papuas_results.length > 0 ? (vowels_count/@papuas_results.length).round(2) : 0
  end

  # GET /papuas/1 or /papuas/1.json
  def show
  end

  # GET /papuas/new
  def new
    @papua = Papua.new
    @segments = Segment.order(no: 1).map { |s| [s.ipa, s.id] }
  end

  # GET /papuas/1/edit
  def edit
    @segments = Segment.order(no: 1).map { |s| [s.ipa, s.id] }
  end

  # POST /papuas or /papuas.json
  def create
    @papua = Papua.new(papua_params)
    @papua.no = Papua.all.size + 1
    @papua.inv = @papua.consonants + ", " + @papua.v_segments
    @papua.count_of_consonants = @papua.consonants.split(",").size
    @papua.count_of_vowels = @papua.v_segments.split(",").size
    @papua.count_of_segments = @papua.count_of_consonants + @papua.count_of_vowels

    respond_to do |format|
      if @papua.save
        format.html { redirect_to @papua, notice: "Papua was successfully created." }
        format.json { render :show, status: :created, location: @papua }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @papua.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /papuas/1 or /papuas/1.json
  def update
    update_segments_relation
    update_counts

    respond_to do |format|
      if @papua.update(papua_params)
        format.html { redirect_to @papua, notice: "Papua was successfully updated." }
        format.json { render :show, status: :ok, location: @papua }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @papua.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /papuas/1 or /papuas/1.json
  def destroy
    @papua.destroy
    respond_to do |format|
      format.html { redirect_to papuas_url, notice: "Papua was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_papua
      @papua = Papua.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def papua_params
      params.require(:papua).permit(
        :language_name, :language_family, :phylum, :iso, :area, :country, :region, :latitude, :longitude, :inv, 
        :consonants, :v_segments, :diphthongs, :source, :notes,
        segment_ids: []
      )
    end

    def update_segments_relation
      new_segments = if params[:papua][:segment_ids].join.empty?
        []
      else
        Segment.in(id: params[:papua][:segment_ids])
      end

      add_segments = new_segments - @papua.segments
      remove_segments = @papua.segments - new_segments
      @papua.add_segment!(add_segments) if add_segments.present?
      @papua.remove_segment!(remove_segments) if remove_segments.present?
    end

    def update_counts
      @papua.inv = @papua.segments.order(no:1).pluck(:ipa).join(", ") + ", " + @papua.v_segments
      @papua.count_of_consonants = @papua.segments.size
      @papua.count_of_vowels = @papua.v_segments.split(",").size
      @papua.count_of_segments = @papua.count_of_consonants + @papua.count_of_vowels
      @papua.save
    end

    def sync_result
      Search.each do |search|
        search.result = ((search.papuas.size.to_f * 100 / Papua.all.size).round(2)).to_s + "%"
        search.save
    end
  end

  protected

  def configure_search
    @search = Papua.search(params[:search])
  end
end
