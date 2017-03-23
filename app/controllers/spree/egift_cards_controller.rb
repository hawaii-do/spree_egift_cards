class Spree::EgiftCardsController < Spree::StoreController

	include Spree::Core::ControllerHelpers::Store if Spree::Store
	include Spree::RegionsHelper 									if Spree::Region
	include Spree::EgiftCardsHelper

	def new
		@egift_card = Spree::EgiftCard.new
	end

	def create
		# begin
		# 	Spree::EgiftCard.transaction do

				#In EgiftCards Helper
				@egift_card = create_egift_card(egift_card_params)

			  @order = @egift_card.create_order(try_spree_current_user)

			  if @egift_card.save!
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

	def egift_card_params
	  params[:egift_card].permit(:recipient_email, :recipient_firstname, :recipient_lastname,
	  	:sender_firstname, :sender_lastname, :original_value, :message)
	end
end
