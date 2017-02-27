class Spree::Admin::EgiftCardsController < Spree::Admin::ResourceController

	def create
		logger.info "==CREATE=="
		@egift_card = Spree::EgiftCard.new
	  @egift_card.attributes = egift_card_params
	  if @egift_card.save
	    flash[:success] = Spree.t(:successfully_created_gift_card)
	    redirect_to admin_egift_cards_path
	  else
	    render :new
	  end
	end

	def collection
	  Spree::EgiftCard.order("created_at desc").page(params[:page]).per(Spree::Config[:orders_per_page])
	end

	def current_store
		Spree::Store.first
	end

	def egift_card_params
	  params[:egift_card].permit(:recipient_email, :recipient_firstname, :recipient_lastname,
	  	:sender_firstname, :sender_lastname, :original_value, :message)
	end

end
