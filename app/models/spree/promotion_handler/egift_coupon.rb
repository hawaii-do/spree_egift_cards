module Spree
  module PromotionHandler
    class EgiftCoupon < Coupon



      def apply
        NIDECKER_LOGGER.info "==APPLY EGIFT COUPON HANDLER"
        if order.coupon_code.present?
          if egift_coupon.present?
            NIDECKER_LOGGER.info ">>>EGIFT COUPON PRESENT"
            handle_present_egift_coupon(egift_coupon)
          else
            NIDECKER_LOGGER.info ">>>EGIFT COUPON NOT PRESENT"
            set_error_code :coupon_code_not_found
          end
        end

        self
      end

      def egift_coupon
        @egift_coupon ||= Spree::EgiftCoupon.active.by_store(order.store).with_code(order.coupon_code).first
      end

      def handle_present_egift_coupon(egift_coupon)
        return promotion_applied if promotion_exists_on_order?(order, egift_coupon)
        unless egift_coupon.eligible?(order)
          self.error = egift_coupon.eligibility_errors.full_messages.first unless egift_coupon.eligibility_errors.blank?
          return (self.error || ineligible_for_this_order)
        end

        # If any of the actions for the promotion return `true`,
        # then result here will also be `true`.
        result = egift_coupon.activate(:order => order)
        NIDECKER_LOGGER.info "===ACTIVATE EGIFT COUPON"
        NIDECKER_LOGGER.info "result: #{result.inspect}"
        if result
          determine_promotion_application_result
        else
          set_error_code :coupon_code_unknown_error
        end
      end

      def determine_promotion_application_result
        set_success_code :coupon_code_applied
      end


    end
  end
end
