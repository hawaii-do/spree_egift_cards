class Spree::Api::V1::CheckBalancesController < Spree::Api::BaseController

	def create
		code	= params[:code]
		pin 	= params[:pin]

		if @egift_card = Spree::EgiftCard.where(code: code, pin: pin).first
			render json: @egift_card
		else
			invalid_ressource!
		end
	end

end