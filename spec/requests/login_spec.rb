require 'rails_helper'

RSpec.describe "Login", type: :request do

	describe "not logged in" do
		it "should be redirected to home page" do
			get "/papuas"
			expect(response).to redirect_to('/users/sign_in')
		end
	end


  describe "logged in" do
    
    before(:context) do
    	@user = create(:user)
   	end

    it "index page" do
    	sign_in @user
    	get "/papuas"
    	expect(response).to have_http_status(:ok)
    end

    after(:context) do
		  @user.destroy
		end

  end
end
