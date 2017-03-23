FactoryGirl.define do
  factory :egift_card, class: Spree::EgiftCard do

  	message 						"Happy birthday !"
  	recipient_email    	"joe@dalton.com"
  	recipient_firstname	"Joe"
  	recipient_lastname  "Dalton"

  	sender_firstname		"Lucky"
		sender_lastname			"Luke"

		original_value			100.0
		current_value				{original_value}
		currency						"USD"
    created_at          1.year.ago


    before(:create) do |card|
      card.store = Spree::Store.where(code: 'jones').first || create(:jones)
      card.regions << (Spree::Region.where(code: 'USA').first || create(:region_usa))
    end

  end
end