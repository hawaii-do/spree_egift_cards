Spree::StoreController.class_eval do

  protected

    # Apply egift card on redeemer's order.
    def apply_gift_code
      if params[:order] && params[:order][:gift_code]
        @order.gift_code = params[:order][:gift_code].delete(' ').upcase
      end
      return true if @order.gift_code.blank?
      if @gift_card = Spree::EgiftCard.find_by_code(@order.gift_code) and @gift_card.order_activatable?(@order)
        unless @gift_card.check_pin?(@order.pin)
          flash[:error] = Spree.t(:invalid_code_or_pin_number)
          return false
        end

        unless @gift_card.same_currency?(@order)
          flash[:error] = Spree.t(:currency_mismatch)
          return false
        end

        unless @gift_card.same_store?(@order)
          flash[:error] = Spree.t(:store_mismatch)
          return false
        end

        unless @gift_card.include_region?(@order)
          flash[:error] = Spree.t(:region_mismatch)
          return false
        end

        @gift_card.apply(@order)
        flash[:success] = Spree.t(:gift_code_applied)
        return true
      else
        flash[:error] = Spree.t(:invalid_code_or_pin_number)
        return false
      end
    end

end
