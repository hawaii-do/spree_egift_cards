require 'spec_helper'

describe Spree::Api::V1::EgiftCardsController, type: :controller do

	let!(:user) { create(:egift_user) }
  let!(:store) { Spree::Store.find_by_code('foobar') || create(:foobar)}
  let!(:region){ Spree::Region.find_by_code('USA')   || create(:egift_region)}

  before(:each) { @routes = Spree::Core::Engine.routes }

  before do
    store.regions << region
    store.save
    allow(controller).to receive_messages(:spree_current_user => user)
  end

	before do
	  stub_api_authentication!
	end

  context "GET new" do

  	it 'returns a valid response' do
  		get :new, format: :json
  		expect(response.status).to eq(200)
  	end

  end

  context "POST create with valid params" do

    params = {:egift_card => {:recipient_email=>'jo@dalton.com',
            :recipient_name => 'Jo Dalton',
            :sender_email => 'lucky@luke.com', :sender_name => 'Lucky Luke',
            :original_value => 100, :message => 'Happy Birthday'}, :format => :json}

    it "has access to current_store" do
      post :create, params
      expect(assigns(:current_store)).to eq(store)
      expect(assigns(:current_store).code).to eq('foobar')
      expect(assigns(:current_store).regions).to be_present
    end

    it "create egift card with a line item" do
      post :create, params
      egift_card = assigns(:egift_card)
      expect(egift_card.code).to be_present
      expect(egift_card.original_value).to eq(100)
    end

    it "create egift_card with store" do
      post :create, params
      egift_card = assigns(:egift_card)
      expect(egift_card.store_id).to eq(store.id)
    end

    it "create egift_card with currency" do
      post :create, params
      egift_card = assigns(:egift_card)
      expect(egift_card.currency).to eq('USD')
    end

    it "create egift_card with region" do
      post :create, params.merge(region: 'USA')
      egift_card = assigns(:egift_card)
      expect(egift_card.regions).to be_present
    end

    it "create variant with code as SKU and price as original value" do
      post :create, params
      egift_card = assigns(:egift_card)
      variant = Spree::Variant.find_by_sku(egift_card.code)
      expect(variant.sku).to eq(egift_card.code)
      expect(variant.price).to eq(egift_card.original_value)
    end

    # it "create an order with same line item as egift card" do
    #   post :create, params
    #   order = assigns(:order)
    #   egift_card = assigns(:egift_card)
    #   expect(order).to be_present
    #   expect(order.line_items.size).to eq(1)
    #   expect(order.line_items.first).to eq(egift_card.line_item)
    # end

    it "rendew show template" do
      post :create, params
      expect(response).to render_template(:show)
    end
  end

end
