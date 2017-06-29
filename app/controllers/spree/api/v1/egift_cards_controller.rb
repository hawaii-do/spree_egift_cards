
class Spree::Api::V1::EgiftCardsController < Spree::Api::BaseController

	include Spree::EgiftCardsControllerConcern
	include Spree::StoresHelper
	# include Spree::RegionsHelper

	def new
		render json: {test: :OK}
	end

	def show
		@egift_card = Spree::EgiftCard.find(params[:id])
	end

	def create
		@egift_card = create_egift_card(egift_card_params)
		unless @egift_card.save
			invalid_resource!(@egift_card) and return
		end

	  # @order = @egift_card.create_order(try_spree_current_user)
	  @variant = @egift_card.create_variant

	  if @egift_card.save
	    respond_with(@egift_card,:status => 201, default_template: 'spree/api/v1/egift_cards/show')
	  else
	    invalid_resource!(@egift_card)
	  end
	end

end
