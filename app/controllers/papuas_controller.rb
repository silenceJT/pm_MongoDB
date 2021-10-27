class PapuasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_papua, only: %i[ show edit update destroy ]
  before_action :verify_email
  #before_action :sync, only: %i[ index show edit ]
  #after_action :sync, only: %i[ update destroy ]
  after_action :sync_result, only: %i[ create ]

  # GET /papuas or /papuas.json
  def index
    @papuas = Papua.all
<<<<<<< HEAD
    
    if params[:search_language].present?
      @papuas = @papuas.where(:language_name => /#{params[:search_language]}/i)
    end

    if params[:search_family].present?
      @papuas = @papuas.where(:language_family => /#{params[:search_family]}/i)
    end

    if params[:search_iso].present?
      @papuas = @papuas.where(:iso => /#{params[:search_iso]}/i)
    end

    if params[:search_country].present?
      @papuas = @papuas.where(:country => /#{params[:search_country]}/i)
    end

    if params[:search_c].present?
      if params[:select_c].present?
        case params[:select_c]
        when "gte"
          @papuas = @papuas.where(:count_of_consonants.gte => params[:search_c])
        when "gt"
          @papuas = @papuas.where(:count_of_consonants.gt => params[:search_c])
        when "eq"
          @papuas = @papuas.where(:count_of_consonants => params[:search_c])
        when "lt"
          @papuas = @papuas.where(:count_of_consonants.lt => params[:search_c])
        else
          @papuas = @papuas.where(:count_of_consonants.lte => params[:search_c])
        end
      end

      #@papuas_3 = @papuas_3.where(:count_of_consonants => params[:search_c])
    end

    if params[:search_v].present?
      if params[:select_v].present?
        case params[:select_v]
        when "gte"
          @papuas = @papuas.where(:count_of_vowels.gte => params[:search_v])
        when "gt"
          @papuas = @papuas.where(:count_of_vowels.gt => params[:search_v])
        when "eq"
          @papuas = @papuas.where(:count_of_vowels => params[:search_v])
        when "lt"
          @papuas = @papuas.where(:count_of_vowels.lt => params[:search_v])
        else
          @papuas = @papuas.where(:count_of_vowels.lte => params[:search_v])
        end
      end
      #@papuas_3 = @papuas_3.where(:count_of_vowels => params[:search_v])
    end

    if params[:search_cv].present?
      if params[:select_cv].present?
        case params[:select_cv]
        when "gte"
          @papuas = @papuas.where(:count_of_segments.gte => params[:search_cv])
        when "gt"
          @papuas = @papuas.where(:count_of_segments.gt => params[:search_cv])
        when "eq"
          @papuas = @papuas.where(:count_of_segments => params[:search_cv])
        when "lt"
          @papuas = @papuas.where(:count_of_segments.lt => params[:search_cv])
        else
          @papuas = @papuas.where(:count_of_segments.lte => params[:search_cv])
        end
      end
      #@papuas_3 = @papuas_3.where(:count_of_segments => params[:search_cv])
    end

    inv_search = Array.new()
    inv_pos = Array.new()
    inv_pos_count = 0
    inv_neg = Array.new()
    inv_pos_final = Array.new()
    inv_neg_final = Array.new()
    final_no = Array.new()
    pos_search = Array.new()

    if params[:search_inv].present?
      inv_search = params[:search_inv].split(" ")
      inv_search.each do |inv|
        if inv.start_with?('-')
          inv_sliced = Array.new()
          inv_sliced = inv.slice!(0)
          @papuas_neg = @papuas.where(:inv => /#{inv}/)
          @papuas_neg.each do |pn|
            inv_neg.push(pn.no)
          end
        # else
        #   pos_search.push(inv)
        #   @papuas_pos = @papuas_3.where(:inv => /#{inv}/)
        #   @papuas_pos.each do |pp|
        #     inv_pos.push(pp.no)
        #   end
        end
      end
      counts_pos = Hash.new(0)
      counts_neg = Hash.new(0)
      # if inv_pos.any?
      #   inv_pos.each { 
      #     |item| counts_pos[item] += 1 
      #     if counts_pos[item] == inv_search.size
      #       inv_pos_final.push(item)
      #     end
      #   }
      # end
      if inv_neg.any?
        inv_neg.each { 
          |item| counts_neg[item] += 1 
          if counts_neg[item] > 0
            inv_neg_final.push(item)
          end
        }
        @papuas_n = @papuas.not_in(:no => inv_neg_final)
      else
        @papuas_n = @papuas.in(:no => inv_neg_final)
      end
      
      

      inv_search = params[:search_inv].split(" ")
      inv_search.each do |inv|
        next if inv.start_with?('-')
        inv_pos_count += 1
        @papuas_pos = @papuas_n.where(:inv => /#{inv}/)
        @papuas_pos.each do |pp|
          inv_pos.push(pp.no)
        end
      end

      if inv_pos.any?
        inv_pos.each { 
          |item| counts_pos[item] += 1 
          if counts_pos[item] == inv_pos_count
            inv_pos_final.push(item)
          end
        }
        @papuas = @papuas_pos.in(:no => inv_pos_final)
      else
        @papuas = @papuas_n
      end
      #@papuas_3 = @papuas_n.full_text_search(pos_search, allow_empty_search: false, match: :all)
      
      # final results returned into @papuas
       
      
    end

    
=======
>>>>>>> advanced-search

    @papuas_results = @papuas
    @papuas_all_size = Papua.all.size
    
    @papuas = @papuas.order(no: 1)
    @papuas_page = Kaminari.paginate_array(@papuas).page(params[:page]).per(15)
    
    other = Array.new()
    @papuas.each do |p3|
      other.push(p3.no)
    end
    @papuas_other = Papua.not_in(:no => other)


    @sum_s = 0
    @sum_c = 0
    @sum_v = 0
    @sum_d = 0
    
    @papuas_results.each do |p_r| 
      @sum_s += p_r.count_of_segments 
      @sum_c += p_r.count_of_consonants
      @sum_v += p_r.count_of_vowels
    end

   

    @avg_s = (@sum_s.to_f/@papuas_results.length).round(2)
    @avg_c = (@sum_c.to_f/@papuas_results.length).round(2)
    @avg_v = (@sum_v.to_f/@papuas_results.length).round(2)
    

    respond_to do |format|
        format.html
        format.json { render json: @papuas }
        format.js
        format.csv { send_data @papuas.to_csv }
        format.xls { send_data papuas.to_csv }
    end

  end

  # GET /papuas/1 or /papuas/1.json
  def show
    @papua.inv = @papua.consonants + ", " + @papua.vowels
    @papua.count_of_consonants = @papua.consonants.split(",").size
    @papua.count_of_vowels = @papua.vowels.split(",").size
    @papua.count_of_segments = @papua.count_of_consonants + @papua.count_of_vowels
    @papua.save

    seg_list = Segment.all
    @seg_hash = Hash.new()
    @seg_array = Array.new()
    for p_c in @papua.consonants.split("\,") do
      for seg in seg_list.entries do
        con = p_c.strip
        if seg.ipa === con
          @seg_hash[con] = seg.id.to_s
          break
        else
          @seg_hash[con] = "none"
        end
      end
    end

    # cons = @papua.consonants.split("\,")
    
    # for i in 0..cons.size-1 do
    #   for j in 0..seg_list.entries.size-1 do
    #     ipa = seg_list.entries[j].ipa
    #     con = cons[i].strip
    #     if con === ipa
    #       @seg_hash[con] = seg_list.entries[j].id.to_s
    #     else
    #       @seg_hash[con] = "none"
    #     end
    #   end
    # end
  end

  # GET /papuas/new
  def new
    @papua = Papua.new
  end

  # GET /papuas/1/edit
  def edit
    @papua.inv = @papua.consonants + ", " + @papua.vowels
    @papua.count_of_consonants = @papua.consonants.split(",").size
    @papua.count_of_vowels = @papua.vowels.split(",").size
    @papua.count_of_segments = @papua.count_of_consonants + @papua.count_of_vowels
    @papua.save
  end

  # POST /papuas or /papuas.json
  def create
    @papua = Papua.new(papua_params)
    @papua.no = Papua.all.size + 1
    @papua.inv = @papua.consonants + ", " + @papua.vowels
    @papua.count_of_consonants = @papua.consonants.split(",").size
    @papua.count_of_vowels = @papua.vowels.split(",").size
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
      params.require(:papua).permit(:language_name, :language_family, :iso, :area, :country, :region, :latitude, :longitude, :inv, :consonants, :vowels, :diphthongs, :source, :notes)
    end

    def verify_email
      #(redirect_to(root_path) unless current_user.email.include?('jt'))
      #add whitelist for users
      whitelist = ["jessewjt@gmail.com", "j.hajek@unimelb.edu.au", "timothy.brickell@unimelb.edu.au"]
      (redirect_to(root_path) unless whitelist.include?(current_user.email))
    end

    # def sync
    #   Papua.each do |papua|
    #     papua.inv = papua.consonants + ", " + papua.vowels
    #     papua.count_of_consonants = papua.consonants.split(",").size
    #     papua.count_of_vowels = papua.vowels.split(",").size
    #     papua.count_of_segments = papua.count_of_consonants + papua.count_of_vowels
    #     papua.save
    #   end
    # end

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
