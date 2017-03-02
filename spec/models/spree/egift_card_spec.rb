require 'spec_helper'

RSpec.describe Spree::EgiftCard do

	let(:egift_card) {FactoryGirl.create(:egift_card)}
	let(:egift_card_with_transactions) {FactoryGirl.create(:egift_card_with_transactions)}

	it "create an instance" do
		expect(egift_card).to be_present
	end

	it "belongs to a purchaser" do
		expect(egift_card.purchaser).to be_present
	end

	it "belongs to a store" do
		expect(egift_card.store).to be_present
	end

	it "has many transactions" do
		expect(egift_card_with_transactions).to be_present
		expect(egift_card_with_transactions.transactions.size).to be >=2
	end
end