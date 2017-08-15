require 'spec_helper'

RSpec.describe Spree::Order do
	let(:user) { create(:egift_user) }
	let(:egift_card) {FactoryGirl.create(:egift_card)}
	let!(:order) {egift_card.create_order(user)}

	context "Instance" do
		it "has egift card" do
			expect(order.has_egift_card?).to be true
		end
	end

end