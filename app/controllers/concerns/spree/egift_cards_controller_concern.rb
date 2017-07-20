module Spree::EgiftCardsControllerConcern
	extend ActiveSupport::Concern

	included do

		def egift_card_params
		  params[:egift_card].permit(:recipient_email, :recipient_firstname, :recipient_lastname,
		  	:sender_firstname, :sender_lastname, :original_value, :message, :recipient_name, :sender_name, :sender_email,
		  	:receive_copy)
		end


		def create_egift_card(egift_card_params)
			@egift_card = Spree::EgiftCard.new
		  @egift_card.attributes 		= egift_card_params
		  @egift_card.currency 			= current_currency
		  @egift_card.store 				= current_store
		  # @egift_card.region 				= current_region	if Spree::Region
		  @egift_card.current_value = params[:egift_card][:original_value]
		  @egift_card.tax_category = Spree::TaxCategory.where(name: 'E-Gift Card', store_id:  @egift_card.store_id).first
		  @egift_card.regions << current_region if current_region
		  @egift_card
		end

	end

	class_methods do

	end
end