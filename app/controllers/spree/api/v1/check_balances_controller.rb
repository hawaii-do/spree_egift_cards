class Spree::Api::V1::CheckBalancesController < Spree::Api::BaseController

	include Spree::StoresHelper

	def create
		logger.debug "CHECK BALANCE"
		logger.debug params.inspect
		code	= params[:code]
		pin 	= params[:pin]

		if @egift_card = Spree::EgiftCard.where(code: code, pin: pin).first
			logger.debug "EgiftCard found"
			render json: @egift_card
		else
			logger.debug "EgiftCard not found"
			render "spree/api/v1/egift_cards/not_found", status: 422
		end
	end

end