module Spree
	class EgiftCardTransaction < ActiveRecord::Base

		belongs_to :egift_card, class_name: 'Spree::EgiftCard'
	  belongs_to :order, class_name: 'Spree::Order'

	  validates :amount, presence: true
	end
end
