require 'rails_helper'

RSpec.describe Papua, type: :model do
  describe "have sound /p/" do
  	it "should return 250" do
  		papua = Papua.search(nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 'p')
  		expect(papua.size).to eq(250)
  	end
  end

  describe "have sound /p/ and dont have sound /t/" do
  	it "should return 15" do
  		papua = Papua.search(nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "p -t")
  		expect(papua.size).to eq(15)
  	end
  end
end
