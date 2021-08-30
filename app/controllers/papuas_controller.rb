class PapuasController < ApplicationController
  before_action :set_papua, only: %i[ show edit update destroy ]

  # GET /papuas or /papuas.json
  def index
    @papuas = Papua.all
    
    #gem full text search
    exc = Array.new()
    inv_search = Array.new()
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
      if params[:search_inc].to_s.include?('B')
        @papuas_3 = @papuas_2.where(:inv => /#{'B'}/)
        @papuas_3 = @papuas_3.full_text_search(params[:search_inc], allow_empty_search: false, match: :all)
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

    inv_no = Array.new()

    if params[:search_inv].present?
      inv_search = params[:search_inv].split(" ")
      inv_search.each do |inv|
        @papuas_3 = @papuas_3.where(:inv => /#{inv}/)
        @papuas_3.each do |p3|
          inv_no.push(p3.no)
        end
      end
      counts = Hash.new(0)
      inv_no_final = Array.new()
      inv_no.each { 
        |item| counts[item] += 1 
        if counts[item] == inv_search.size
          inv_no_final.push(item)
        end
      }
      @papuas_3 = @papuas_3.in(:no => inv_no_final)
      #@papuas_3 = @papuas_3.where(:inv => /#{params[:search_inv]}/)
    end

    if params[:search_c].present?
      if params[:select_c].present?
        case params[:select_c]
        when "gte"
          @papuas_3 = @papuas_3.where(:count_of_consonants.gte => params[:search_c])
        when "gt"
          @papuas_3 = @papuas_3.where(:count_of_consonants.gt => params[:search_c])
        when "eq"
          @papuas_3 = @papuas_3.where(:count_of_consonants => params[:search_c])
        when "lt"
          @papuas_3 = @papuas_3.where(:count_of_consonants.lt => params[:search_c])
        else
          @papuas_3 = @papuas_3.where(:count_of_consonants.lte => params[:search_c])
        end
      end

      #@papuas_3 = @papuas_3.where(:count_of_consonants => params[:search_c])
    end

    if params[:search_v].present?
      if params[:select_v].present?
        case params[:select_v]
        when "gte"
          @papuas_3 = @papuas_3.where(:count_of_vowels.gte => params[:search_v])
        when "gt"
          @papuas_3 = @papuas_3.where(:count_of_vowels.gt => params[:search_v])
        when "eq"
          @papuas_3 = @papuas_3.where(:count_of_vowels => params[:search_v])
        when "lt"
          @papuas_3 = @papuas_3.where(:count_of_vowels.lt => params[:search_v])
        else
          @papuas_3 = @papuas_3.where(:count_of_vowels.lte => params[:search_v])
        end
      end
      #@papuas_3 = @papuas_3.where(:count_of_vowels => params[:search_v])
    end

    if params[:search_cv].present?
      if params[:select_cv].present?
        case params[:select_cv]
        when "gte"
          @papuas_3 = @papuas_3.where(:count_of_segments.gte => params[:search_cv])
        when "gt"
          @papuas_3 = @papuas_3.where(:count_of_segments.gt => params[:search_cv])
        when "eq"
          @papuas_3 = @papuas_3.where(:count_of_segments => params[:search_cv])
        when "lt"
          @papuas_3 = @papuas_3.where(:count_of_segments.lt => params[:search_cv])
        else
          @papuas_3 = @papuas_3.where(:count_of_segments.lte => params[:search_cv])
        end
      end
      #@papuas_3 = @papuas_3.where(:count_of_segments => params[:search_cv])
    end

    @papuas_results = @papuas_3
    @papuas_all = Papua.all
    @papuas = @papuas_3
    #@papuas = @papuas.order(no: 1)
    @papuas_page = Kaminari.paginate_array(@papuas).page(params[:page]).per(15)
    
    other = Array.new()
    @papuas_3.each do |p3|
      other.push(p3.no)
    end
    @papuas_other = Papua.not_in(:no => other)


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
    @lng_results = Array.new;
    @lat_results = Array.new;
    @name_results = Array.new;
    @family_results = Array.new;
    @country_results = Array.new;
    @lng_other = Array.new;
    @lat_other = Array.new;
    @name_other = Array.new;
    @family_other = Array.new;
    @country_other = Array.new;
    
    @papuas_results.each do |p_r| 
      @sum_s += p_r.count_of_segments 
      @sum_c += p_r.count_of_consonants
      @sum_v += p_r.count_of_vowels
      #@sum_d += p_r.count_of_diphthongs
      @lng_results.push(p_r.longitude)
      @lat_results.push(p_r.latitude)
      @name_results.push(p_r.language_name)
      @family_results.push(p_r.language_family)
      @country_results.push(p_r.country)
    end

    @papuas_other.each do |p_o| 
      @lng_other.push(p_o.longitude)
      @lat_other.push(p_o.latitude)
      @name_other.push(p_o.language_name)
      @family_other.push(p_o.language_family)
      @country_other.push(p_o.country)
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
