Spree::Adjustment.class_eval do
  scope :egift_cards, -> { where(:source_type => 'Spree::EgiftCard') }
end