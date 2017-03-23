module Spree::EgiftCardsHelper
	include Spree::BaseHelper

	def create_egift_card(egift_card_params)
		@egift_card = Spree::EgiftCard.new
	  @egift_card.attributes 		= egift_card_params
	  @egift_card.currency 			= current_currency
	  @egift_card.store 				= current_store		if Spree::Store
	  # @egift_card.region 				= current_region	if Spree::Region
	  @egift_card.current_value = params[:egift_card][:original_value]
	  @egift_card.tax_category = Spree::TaxCategory.where(name: 'E-Gift Card', store_id:  @egift_card.store_id).first
	  @egift_card.regions << current_region
	  @egift_card.save!
	  @egift_card
	end
end
