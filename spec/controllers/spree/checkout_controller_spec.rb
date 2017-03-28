require 'spec_helper'

RSpec.describe Spree::CheckoutController, type: :controller do
	let!(:user) { create(:egift_user) }
	let(:egift_card) {FactoryGirl.create(:egift_card)}
	let(:order) { FactoryGirl.create(:order_for_egift) }

	before(:each) { @routes = Spree::Core::Engine.routes }

	before do
    allow(controller).to receive_messages try_spree_current_user: user
    allow(controller).to receive_messages spree_current_user: user
    allow(controller).to receive_messages current_order: order
  end

	context "update" do
		before do
			allow(controller).to receive_messages check_authorization: true
			allow(controller).to receive_messages ensure_sufficient_stock_lines: true
			allow(controller).to receive_messages ensure_checkout_allowed: true
			allow(controller).to receive_messages set_state_if_present: true
			allow(controller).to receive_messages ensure_valid_state: true
			allow(order).to receive_messages item_total: 30.0
		end

		it "apply gift card if code is correct" do
			put :update, state: 'payment', order: {gift_code: egift_card.code, pin: egift_card.pin}
			expect(assigns(:order).gift_code).to eq(egift_card.code)
			expect(assigns(:gift_card).code).to eq(egift_card.code)
			expect(egift_card.order_activatable?(assigns(:order))).to be true
			expect(assigns(:order).item_total).to eq(30.0)
			expect(egift_card.compute_amount(assigns(:order))).to eq(-30.0)
			expect(flash[:success]).to be_present
			expect(response.status).to eq(302)
		end

		it "doesn't apply gift card if currency mismatch" do
			egift_card.currency = 'FOO'
			egift_card.save
			put :update, state: 'payment', order: {gift_code: egift_card.code}
			expect(assigns(:order).gift_code).to eq(egift_card.code)
			expect(assigns(:gift_card).code).to eq(egift_card.code)
			expect(egift_card.order_activatable?(assigns(:order))).to be true
			expect(flash[:error]).to be_present
			expect(response.status).to eq(200)
		end

		it "doesn't apply gift card if region mismatch" do
			order.region = Spree::Region.create(code: 'TOTO')
			egift_card.save
			put :update, state: 'payment', order: {gift_code: egift_card.code}
			expect(assigns(:order).gift_code).to eq(egift_card.code)
			expect(assigns(:gift_card).code).to eq(egift_card.code)
			expect(egift_card.order_activatable?(assigns(:order))).to be true
			expect(flash[:error]).to be_present
			expect(response.status).to eq(200)
		end

		it "doesn't apply gift card if store mismatch" do
			order.store = Spree::Store.create(code: 'TOTO')
			egift_card.save
			put :update, state: 'payment', order: {gift_code: egift_card.code}
			expect(assigns(:order).gift_code).to eq(egift_card.code)
			expect(assigns(:gift_card).code).to eq(egift_card.code)
			expect(egift_card.order_activatable?(assigns(:order))).to be true
			expect(flash[:error]).to be_present
			expect(response.status).to eq(200)
		end


		it "doesn't apply gift if code is incorrect" do
			put :update, state: 'payment', order: {gift_code: 'WRONG'}
			expect(flash[:error]).to be_present
			expect(response.status).to eq(200)
		end
	end

end