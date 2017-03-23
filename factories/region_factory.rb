FactoryGirl.define do
	factory :egift_region, class: Spree::Region do
		code 			'USA'
		name 			'USA'
		currency 	'USD'
		default true
	end
end