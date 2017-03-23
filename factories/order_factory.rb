FactoryGirl.define do
  factory :order_for_egift, class: Spree::Order do
    association :user, factory: :egift_user
    bill_address
    completed_at nil
    email { user.email }
    item_total 30

    transient do
      line_items_price BigDecimal.new(10)
    end

    before(:create) do |order|
      order.store = Spree::Store.where(code: 'jones').first || create(:jones)
      order.region = Spree::Region.where(code: 'USA').first || create(:region_usa)
    end
  end
end
