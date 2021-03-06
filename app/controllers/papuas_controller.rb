class PapuasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_papua, only: %i[ show edit update destroy ]
  before_action :verify_email
  #before_action :sync, only: %i[ index show edit ]
  #after_action :sync, only: %i[ update destroy ]
  after_action :sync_result, only: %i[ create ]

  # GET /papuas or /papuas.json
  def index
    

    @papuas = Papua.search(params[:language_name], params[:language_family], params[:iso], params[:area], 
      params[:country], params[:region], params[:c_size], params[:c_compare], params[:v_size], 
      params[:v_compare], params[:total_size], params[:total_compare], params[:inv])

    @papuas_results = @papuas
    @papuas_all_size = Papua.count
    
    @papuas = @papuas.order(no: 1)
    @papuas_page = Kaminari.paginate_array(@papuas).page(params[:page]).per(15)
    
    other = Array.new()
    @papuas.each do |p3|
      other.push(p3.no)
    end
    @papuas_other = Papua.not_in(:no => other)

    # must at the end
    respond_to do |format|
        format.html { }
        format.json { render json: @papuas }
        format.js { render :layout => false }
        format.csv { send_data @papuas.to_csv }
        format.xls
    end


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
      whitelist = ["jessewjt@gmail.com", "j.hajek@unimelb.edu.au", "timothy.brickell@unimelb.edu.au", "test@example.com"]
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
