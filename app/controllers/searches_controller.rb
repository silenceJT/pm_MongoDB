class SearchesController < ApplicationController
  #after_action :sync, only: %i[ create ]

	def index
		@searches = Search.all
		respond_to do |format|
        format.html
        format.json { render json: @search.papuas }
        format.js
        format.csv { send_data @search.papuas.to_csv }
        format.xls
    end
	end

	def new
		@search = Search.new
	end

	def create
		@search = Search.new(search_params)
		@search.result = ((@search.papuas.size.to_f * 100 / Papua.all.size).round(2)).to_s + "%"
		respond_to do |format|
      if @search.save
        format.html { redirect_to @search, notice: "Search was successfully created." }
        format.json { render :show, status: :created, location: @search }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
	end

	def show
		@search = Search.find(params[:id])
		respond_to do |format|
        format.html
        format.json { render json: @search.papuas }
        format.js
        format.csv { send_data @search.papuas.to_csv }
        format.xls
    end
	end

	def destroy
		@search = Search.find(params[:id])
    @search.destroy
    respond_to do |format|
      format.html { redirect_to searches_url, notice: "Search was successfully destroyed." }
      format.json { head :no_content }
    end
  end

	private
	def search_params
		params.require(:search).permit(:language_name, :language_family, :iso, :area, :country, :region, :inv, :c_compare, :c_size, :v_compare, :v_size, :total_compare, :total_size)
	end

	# def sync
	# 	Search.each do |search|
	# 		search.result = ((search.papuas.size.to_f * 100 / Papua.all.size).round(2)).to_s + "%"
	# 		search.save
	# 	end
	# end

end
