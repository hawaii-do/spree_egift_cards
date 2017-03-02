Spree::Variant.class_eval do

	belongs_to :egift_card, class_name: 'Spree::EgiftCard', foreign_key: :product_id

	def product
		Spree::Product.unscoped { super } || egift_card
	end

end