require 'spec_helper'

RSpec.describe Spree::EgiftCardsController, type: :controller do
	let!(:user) { create(:egift_user) }
	let(:region){ Spree::Region.first || Spree::Region.create!(code: 'REGION1', name: 'My Region1' )} if Spree::Region
	let(:store) { Spree::Store.first }

	before(:each) { @routes = Spree::Core::Engine.routes }

  before do
    allow(controller).to receive_messages(:spree_current_user => user)
  end

	context "GET new" do
		it "render new template" do
			get :new
			expect(assigns(:egift_card)).to be_a_new(Spree::EgiftCard)
			expect(response).to render_template("new")
		end
	end

	context "POST create with valid params" do
		params = {:egift_card => {:recipient_email=>'recipient@gmail.com', :recipient_firstname=>'Jo',
						:recipient_lastname => 'Dalton',
						:sender_firstname => 'Lucky', :sender_lastname => 'Luke',
						:original_value => 100, :message => 'Happy Birthday'}}
		it "create egift card with a line item" do
			post :create, params
			egift_card = assigns(:egift_card)
			expect(egift_card.code).to be_present
			expect(egift_card.original_value).to eq(100)
			expect(egift_card.store_id).to eq(store.id)
			expect(egift_card.line_item).to be_present
		end

		it "create variant with code as SKU and price as original value" do
			post :create, params
			egift_card = assigns(:egift_card)
			variant = Spree::Variant.find_by_sku(egift_card.code)
			expect(variant.sku).to eq(egift_card.code)
			expect(variant.price).to eq(egift_card.original_value)
		end

		it "create an order with same line item as egift card" do
			post :create, params
			order = assigns(:order)
			egift_card = assigns(:egift_card)
			expect(order).to be_present
			expect(order.line_items.size).to eq(1)
			expect(order.line_items.first).to eq(egift_card.line_item)
		end

		it "redirects to cart path" do
			post :create, params
			expect(response).to redirect_to(cart_path)
		end
	end


end
