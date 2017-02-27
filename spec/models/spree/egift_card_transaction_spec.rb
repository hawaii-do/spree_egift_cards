require 'rails_helper'

RSpec.describe Spree::EgiftCardTransaction, type: :model do

  let(:transaction) {FactoryGirl.create(:egift_card_transaction)}

  it "belongs to an egift card" do
  	expect(transaction.egift_card).to be_present
  end
end
