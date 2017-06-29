Spree::Api::V1::CheckoutsController.class_eval do

	Spree::PermittedAttributes.checkout_attributes << :gift_code
  Spree::PermittedAttributes.checkout_attributes << :pin

  def update
    load_order(true)
    authorize! :update, @order, order_token

    if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env)

    	if @order.gift_code.present?
    		apply_result, apply_message = apply_gift_code
    	  render(json: {error: apply_message}, status: 500) and return unless apply_result
    	end

      if current_api_user.has_spree_role?('admin') && user_id.present?
        @order.associate_user!(Spree.user_class.find(user_id))
      end

      return if after_update_attributes

      if @order.completed? || @order.next
        state_callback(:after)
        respond_with(@order, default_template: 'spree/api/v1/orders/show')
      else
        respond_with(@order, default_template: 'spree/api/v1/orders/could_not_transition', status: 422)
      end
    else
      invalid_resource!(@order)
    end
  end


  protected

    # Apply egift card on redeemer's order.
    def apply_gift_code
      if params[:order] && params[:order][:gift_code]
        @order.gift_code = params[:order][:gift_code].delete(' ').upcase
      end
      return true if @order.gift_code.blank?
      if @gift_card = Spree::EgiftCard.find_by_code(@order.gift_code) and @gift_card.order_activatable?(@order)
        unless @gift_card.check_pin?(@order.pin)
          return false, Spree.t(:invalid_code_or_pin_number)
        end

        unless @gift_card.same_currency?(@order)
          return false, Spree.t(:currency_mismatch)
        end

        unless @gift_card.same_store?(@order)
          return false, Spree.t(:store_mismatch)
        end

        unless @gift_card.include_region?(@order)
          return false, Spree.t(:region_mismatch)
        end

        @gift_card.apply(@order)
        return true, Spree.t(:gift_code_applied)
      else
        return false, Spree.t(:invalid_code_or_pin_number)
      end
    end

end
