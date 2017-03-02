class Spree::Admin::EgiftCardsController < Spree::Admin::ResourceController

	def collection
	  Spree::EgiftCard.order("created_at desc").page(params[:page]).per(Spree::Config[:orders_per_page])
	end

	def current_store
		Spree::Store.first
	end



end
