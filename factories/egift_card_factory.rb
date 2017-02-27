FactoryGirl.define do
  factory :egift_card, class: Spree::EgiftCard do

  	message 						"Happy birthday !"
  	recipient_email    	"joe@dalton.com"
  	recipient_firstname	"Joe"
  	recipient_lastname  "Dalton"

  	sender_firstname		"Lucky"
		sender_lastname			"Luke"

		original_value			"100"
		current_value				{original_value}
		currency						"USD"
    code                SecureRandom.urlsafe_base64(8)

		association :purchaser, factory: :jones_user

    before(:create) do |card|
      card.store = Spree::Store.where(code: 'jones').first || create(:jones)
      card.region = Spree::Region.where(code: 'USA').first || create(:region_usa)
    end

    factory :egift_card_with_transactions do
      after(:create) do |card|
        create(:egift_card_transaction, egift_card: card)
        create(:egift_card_transaction, egift_card: card)
      end
    end
  end
end