module Spree
  class EgiftCoupon < EgiftCard

    UNACTIVATABLE_ORDER_STATES = ["complete", "awaiting_return", "returned"]


  	include Spree::CalculatedAdjustments

  	before_validation :set_calculator

  	def self.with_code(code)
  	  where('spree_egift_cards.code = ?', code.upcase)
  	end

  	def self.active
  	  where('spree_egift_cards.purchased_at < ?', Time.current)
  	end

    def order_activatable?(order)
      order &&
      created_at < order.created_at &&
      current_value > 0 &&
      !UNACTIVATABLE_ORDER_STATES.include?(order.state)
    end

  	def activate(payload)
  		logger.info "===ACTIVATE EGIFT COUPON"
      order = payload[:order]
      payload[:promotion] = self
      true
    end

    def eligible?(order)
      !purchased_at.nil?
    end

  	def apply(order)
      NIDECKER_LOGGER.info "APPLY ORDER"
  	  # Nothing to do if the gift card is already associated with the order
  	  # return if order.gift_credit_exists?(self)
  	  order.update!
  	  adj = Spree::Adjustment.create!(
  	        amount: compute_amount(order),
  	        order: order,
  	        adjustable: order,
  	        source: self,
  	        mandatory: true,
  	        label: "#{Spree.t(:egift_card)}"
  	      )
      NIDECKER_LOGGER.info "Adjustment = #{adj.inspect}"
  	  order.update!
  	end

  	def compute_amount(order)
      calc = Spree::EgiftCalculator.new
      calc.compute(order, self)
    end

  end
end