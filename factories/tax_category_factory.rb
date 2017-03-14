FactoryGirl.define do
  factory :egift_tax_category, class: Spree::TaxCategory do
    name 'E-Gift Card'
    store_id Spree::Store.first || create(:foobar)
  end
end