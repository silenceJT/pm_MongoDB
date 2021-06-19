class PapuasController < ApplicationController
  before_action :set_papua, only: %i[ show edit update destroy ]

  # GET /papuas or /papuas.json
  def index
    @papuas = Papua.all
    @entry = Array.new
    @papuas = Papua.full_text_search(params[:search], allow_empty_search: true, match: :all)
    @entry = @papuas
    @papuas = @papuas.order_by(no: 1)
    @papuas = Kaminari.paginate_array(@papuas).page(params[:page]).per(15)

    respond_to do |format|
        format.html
        format.json { render json: @papuas }
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
