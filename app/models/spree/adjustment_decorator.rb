Spree::Adjustment.class_eval do
  scope :egift_coupon, -> { where(:source_type => 'Spree::EgiftCoupon') }
end