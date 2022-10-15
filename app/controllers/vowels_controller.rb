class VowelsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_email
  before_action :set_vowel, only: %i[ show edit update destroy ]

  # GET /vowels or /vowels.json
  def index
    @vowels = Vowel.all.order(no: 1)
  end

  # GET /vowels/1 or /vowels/1.json
  def show
  end

  # GET /vowels/new
  def new
    @vowel = Vowel.new
  end

  # GET /vowels/1/edit
  def edit
  end

  # POST /vowels or /vowels.json
  def create
    @vowel = Vowel.new(vowel_params)
    @vowel.no = Vowel.last.no + 1

    respond_to do |format|
      if @vowel.save
        format.html { redirect_to @vowel, notice: "Vowel was successfully created." }
        format.json { render :show, status: :created, location: @vowel }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vowel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vowels/1 or /vowels/1.json
  def update
    respond_to do |format|
      if @vowel.update(vowel_params)
        format.html { redirect_to @vowel, notice: "Vowel was successfully updated." }
        format.json { render :show, status: :ok, location: @vowel }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vowel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vowels/1 or /vowels/1.json
  def destroy
    @vowel.destroy
    respond_to do |format|
      format.html { redirect_to vowels_url, notice: "Vowel was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vowel
      @vowel = Vowel.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vowel_params
      params.require(:vowel).permit(:no, :ipa, :short, :lengthened, :nasalised, :oral)
    end
end
