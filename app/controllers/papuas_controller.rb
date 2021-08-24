class PapuasController < ApplicationController
  before_action :set_papua, only: %i[ show edit update destroy ]

  # GET /papuas or /papuas.json
  def index
    @papuas = Papua.all
    
    #gem full text search
    exc = Array.new()
    if params[:search_exc].present?
      @papuas_1 = Papua.full_text_search(params[:search_exc], allow_empty_search: false, match: :any)
      @papuas_1.each do |p1|
        exc.push(p1.no)
      end
      @papuas_2 = Papua.not_in(:no => exc)
    else
      @papuas_2 = Papua.all
    end
    
    if params[:search_inc].present?
      if params[:search_inc].to_s.include?('or')
        @papuas_3 = @papuas_2.full_text_search(params[:search_inc], allow_empty_search: false, match: :any)
      else
        @papuas_3 = @papuas_2.full_text_search(params[:search_inc], allow_empty_search: false, match: :all)
      end
    else
      @papuas_3 = @papuas_2
    end

    if params[:search_language].present?
      @papuas_3 = @papuas_3.where(:language_name => /#{params[:search_language]}/i)
    end

    if params[:search_family].present?
      @papuas_3 = @papuas_3.where(:language_family => /#{params[:search_family]}/i)
    end

    if params[:search_iso].present?
      @papuas_3 = @papuas_3.where(:iso => /#{params[:search_iso]}/i)
    end

    if params[:search_country].present?
      @papuas_3 = @papuas_3.where(:country => /#{params[:search_country]}/i)
    end

    if params[:search_inv].present?
      @papuas_3 = @papuas_3.where(:inv => /#{params[:search_inv]}/i)
    end

    if params[:search_c].present?
      @papuas_3 = @papuas_3.where(:count_of_consonants => params[:search_c])
    end

    if params[:search_v].present?
      @papuas_3 = @papuas_3.where(:count_of_vowels => params[:search_v])
    end

    if params[:search_cv].present?
      @papuas_3 = @papuas_3.where(:count_of_segments => params[:search_cv])
    end

    @papuas_results = @papuas_3
    @papuas_all = Papua.all
    @papuas = @papuas_3
    @papuas = @papuas.order(no: 1)
    @papuas = Kaminari.paginate_array(@papuas).page(params[:page]).per(15)


    #@papuas_2 = Papua.all.entries.without(@papuas_1)
    #@papuas = @papuas_2.full_text_search(params[:search_inc], allow_empty_search: false, match: :all)
    #@papuas = Papua.full_text_search(params[:search_inc], allow_empty_search: true, match: :all)
    

    #mongoDB text search
    #@papuas = Papua.text_search(params[:search_inc])
    #@papuas_results = @papuas
    #@papuas_all = Papua.all
    #@papuas = @papuas.order(no: 1)
    #@papuas = Kaminari.paginate_array(@papuas).page(params[:page]).per(15)

    @sum_s = 0
    @sum_c = 0
    @sum_v = 0
    @sum_d = 0
    @lng = Array.new;
    @lat = Array.new;
    @name = Array.new;
    @family = Array.new;
    @country = Array.new;
    
    @papuas_results.each do |p_r| 
      @sum_s += p_r.count_of_segments 
      @sum_c += p_r.count_of_consonants
      @sum_v += p_r.count_of_vowels
      #@sum_d += p_r.count_of_diphthongs
      @lng.push(p_r.longitude)
      @lat.push(p_r.latitude)
      @name.push(p_r.language_name)
      @family.push(p_r.language_family)
      @country.push(p_r.country)
    end

    @avg_s = (@sum_s.to_f/@papuas_results.length).round(2)
    @avg_c = (@sum_c.to_f/@papuas_results.length).round(2)
    @avg_v = (@sum_v.to_f/@papuas_results.length).round(2)
    

    respond_to do |format|
        format.html
        format.json { render json: @papuas }
        format.js
        format.csv { send_data @papuas.to_csv }
        format.xls
    end

  end

  # GET /papuas/1 or /papuas/1.json
  def show
  end

  # GET /papuas/new
  def new
    @papua = Papua.new
  end

  # GET /papuas/1/edit
  def edit
  end

  # POST /papuas or /papuas.json
  def create
    @papua = Papua.new(papua_params)

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
      params.require(:papua).permit(:language, :language_family, :iso, :country, :latitude, :longitude, :inv)
    end

  protected

    def configure_search
      @search = Papua.search(params[:search])
    end
      
end
