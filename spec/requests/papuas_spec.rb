require 'rails_helper'

RSpec.describe "Papuas", type: :request do
	let(:valid_attributes) {
    {
			language_name: "test",
			language_family: "",
			iso: "",
			area: "",
			country: "",
			region: "",
			latitude: "",
			longitude: "",
			inv: "",
			consonants: "p",
			vowels: "i",
			diphthongs: "",
			source: "",
			notes: ""
		}
  }

  let(:new_attributes) {
    {
			language_name: "test_new",
			language_family: "",
			iso: "",
			area: "",
			country: "",
			region: "",
			latitude: "",
			longitude: "",
			inv: "",
			consonants: "p, t",
			vowels: "i",
			diphthongs: "",
			source: "",
			notes: ""
		}
  }

	before(:context) do
    @user = create(:user)
  end

  describe "GET /index" do
    it "should get index page" do
    	sign_in @user
    	get papuas_path
    	expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "should get first language show page" do
    	sign_in @user
    	papua1 = Papua.first
    	get papua_url(papua1)
    	expect(response).to be_successful
    end
  end

  describe "GET /edit" do
  	it "should get edit page" do
    	sign_in @user
    	papua1 = Papua.first
    	get edit_papua_url(papua1)
    	expect(response).to be_successful
    end
  end

  describe "POST /create" do
  	it "creates a new Papua language" do
    	sign_in @user
    	expect {
    		post papuas_url, params: { 
    			papua: valid_attributes
    		}
    	}.to change(Papua, :count).by(1)
    end
  end

	after(:context) do
	  @user.destroy
	end
	
end
