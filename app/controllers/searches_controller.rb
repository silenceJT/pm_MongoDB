class SearchesController < ApplicationController

	def index
		@searches = Search.all
	end

	def new
		@search = Search.new
	end

	def create
		@search = Search.new(search_params)
		#redirect_to @search
		respond_to do |format|
      if @search.save
        format.html { redirect_to @search, notice: "" }
        format.json { render :show, status: :created, location: @search }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
	end

	def show
		@search = Search.find(params[:id])
	end

	private
	def search_params
		params.require(:search).permit(:language_name, :language_family, :iso, :area, :country, :region, :inv, :c_compare, :c_size, :v_compare, :v_size, :total_compare, :total_size)
	end
end
