require 'spec_helper'

describe Spree::Api::V1::CheckBalancesController, type: :controller do

	before(:each) { @routes = Spree::Core::Engine.routes }

	before do
	  stub_api_authentication!
	end


  context "with correct code and pin" do
  	let(:egiftcard){create(:egift_card)}


    it "return egiftcard" do
    	params = {code: egiftcard.code, pin: egiftcard.pin}
      post :create, params
      expect(json_response["code"]).to eq(egiftcard.code)
      expect(json_response["pin"]).to eq(egiftcard.pin)
      expect(json_response["current_value"]).to eq(egiftcard.current_value.to_s)
    end
  end



end