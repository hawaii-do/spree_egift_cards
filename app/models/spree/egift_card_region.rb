class Spree::EgiftCardRegion < ActiveRecord::Base
  belongs_to :egift_card, class_name: 'Spree::EgiftCard'
  belongs_to :region, class_name: 'Spree::Region'
end