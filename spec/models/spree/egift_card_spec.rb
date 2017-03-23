require 'spec_helper'

RSpec.describe Spree::EgiftCard do

	let(:egift_card) {FactoryGirl.create(:egift_card)}
	let(:egift_card_with_transactions) {FactoryGirl.create(:egift_card_with_transactions)}

	context "Instance" do
		it "has a code" do
			expect(egift_card.code).to be_present
		end

		it "belongs to a store" do
			expect(egift_card.store).to be_present
		end

		it "has and belongs to regions" do
			expect(egift_card.regions).to be_present
		end

		it "has default name and description" do
			expect(egift_card.name).to eq('Egift Card')
			expect(egift_card.description).to eq('A convenient and flexible way to share products with family and friends.')
		end

	end

	context "#create_variant" do
		let(:variant) {egift_card.create_variant}
		it "create a specific variant object" do
			expect(variant.sku).to eq(egift_card.code)
			expect(variant.price).to eq(egift_card.original_value)
			expect(variant.currency).to eq(egift_card.currency)
			expect(variant.id).to be >0
		end
	end

	context "#build_line_item" do
		let(:line_item) {egift_card.build_line_item}
		it "prepare line item with variant for order" do
			expect(line_item.price).to eq(egift_card.original_value)
			expect(line_item.variant).to be_present
		end
	end

	context "#create_order" do
		let(:user) {create(:egift_user)}
		let(:order) {egift_card.create_order(user)}
		it "create an egift card's order for user" do
			expect(order.user_id).to be_present
			expect(order.line_items).to be_present
			expect(egift_card.order).to eq(order)
			expect(egift_card.line_item).to eq(order.line_items.first)
		end
	end

	context '#debit' do
		it 'subtract used amount from the current value and create a transaction' do
			egift_card.debit(-25, nil)
			egift_card.reload
			expect(egift_card.current_value).to eq(egift_card.original_value-25)
			transaction = egift_card.transactions.first
			expect(transaction.amount.to_f).to eq(-25.0)
		end

		it 'raise an error when attempting to debit an amount higher than the current value' do
       expect{egift_card.debit(-(egift_card.current_value + 30), nil)}.to raise_error('Cannot debit gift card by amount greater than current value.')
    end
	end

	context '#compute_amount' do
		let(:small_order) {Spree::Order.new(item_total: 30, ship_total: 10, additional_tax_total: 10)}
		it 'calculate the order total if less than egift card current value' do
			expect(egift_card.compute_amount(small_order)).to eq(-50.0)
		end

		let(:big_order) {Spree::Order.new(item_total: 300, ship_total: 10, additional_tax_total: 10)}
		it 'calculate the egift card current value if less than order total' do
			expect(egift_card.compute_amount(big_order)).to eq(-100.0)
		end
	end

	context '#apply' do
		let(:order) {Spree::Order.create!}
		it 'create order adjustment with amount equal to order total' do
			egift_card.apply(order)
			adjustments = order.adjustments.reload
			expect(adjustments).to be_present
		end
	end
end