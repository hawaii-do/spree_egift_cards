Spree::LineItem.class_eval do

  has_one :egift_card, dependent: :destroy

end