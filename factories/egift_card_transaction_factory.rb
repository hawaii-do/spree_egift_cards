FactoryGirl.define do
  factory :egift_card_transaction, class: Spree::EgiftCardTransaction do

  	amount 10.25

  	egift_card

  end
end