require_dependency 'spree/calculator'

module Spree
  class EgiftCalculator < Spree::Calculator

    def self.description
      Spree.t(:egift_coupon_calculator)
    end

    def compute(order, egift_coupon)
      logger.info "===COMPUTE EGIFT CALCULATOR"
      # Ensure a negative amount which does not exceed the sum of the order's item_total, ship_total, and
      # tax_total, minus other credits.
      credits = order.adjustments.select{|a|a.amount < 0 && a.source_type != 'Spree::GiftCoupon'}.map(&:amount).sum
      logger.info "CREDITS: #{credits.inspect}"
      [(order.item_total + order.ship_total + order.additional_tax_total + credits), egift_coupon.current_value].min * -1
    end

  end
end