class Spree::EgiftCardsController < Spree::StoreController

	include Spree::Core::ControllerHelpers::Store if Spree::Store
	include Spree::RegionsHelper 									if Spree::Region

	def new
		@egift_card = Spree::EgiftCard.new
	end

	def create
		# begin
		# 	Spree::EgiftCard.transaction do

				@egift_card = Spree::EgiftCard.new
			  @egift_card.attributes 		= egift_card_params
			  @egift_card.currency 			= current_currency
			  @egift_card.store 				= current_store		if Spree::Store
			  # @egift_card.region 				= current_region	if Spree::Region
			  @egift_card.current_value = params[:egift_card][:original_value]
			  @egift_card.tax_category = Spree::TaxCategory.where(name: 'E-Gift Card', store_id:  @egift_card.store_id).first
			  @egift_card.regions << current_region
			  @egift_card.save!

			  variant = Spree::Variant.new(sku: @egift_card.code, price: @egift_card.original_value.to_f)
			  variant.product_id = @egift_card.id
			  variant.track_inventory = false
			  variant.tax_category_id = @egift_card.tax_category_id
			  variant.regions << current_region
			  variant.is_master = true
			  variant.currency = @egift_card.currency
			  variant.save(validate: false)

			  NIDECKER_LOGGER.info "VARIANT CREATED: #{variant.inspect}"

			  @order = current_order(create_order_if_necessary: true)
  			@order.currency = current_currency

			  line_item = Spree::LineItem.new(quantity: 1)
			  line_item.order = @order
			  line_item.variant = variant
        line_item.price = @egift_card.original_value.to_f
        line_item.currency = @egift_card.currency
        line_item.tax_category_id = @egift_card.tax_category_id
        line_item.save(validate: false)

        NIDECKER_LOGGER.info "LINE ITEM CREATED: #{line_item.inspect}"


        @order.line_items << line_item
        @order.update_totals
        @order.save!

        NIDECKER_LOGGER.info "ORDER CREATED: #{@order.inspect}"

        @egift_card.order = @order
        @egift_card.line_item = line_item
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
