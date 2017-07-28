class Spree::EgiftCardsController < Spree::StoreController

	#include Spree::Core::ControllerHelpers::Store
	include Spree::EgiftCardsControllerConcern
	include Spree::StoresHelper
	include Spree::RegionsHelper


	def new
		@egift_card = Spree::EgiftCard.new
	end

	def create
		# begin
		# 	Spree::EgiftCard.transaction do

				#In EgiftCards Helper
				@egift_card = create_egift_card(egift_card_params)
				unless @egift_card.save
					render :new and return
				end

				@variant = @egift_card.create_variant
			  @order = @egift_card.create_order(try_spree_current_user)


			  if @egift_card.save
			    flash[:success] = Spree.t(:successfully_created_gift_card)
			    redirect_to cart_path
			  else
			    render :new
			  end
		# 	end
		# rescue  ActiveRecord::RecordInvalid
		# 	render :new
		# end
	end



end
