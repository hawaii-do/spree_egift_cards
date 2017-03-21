Spree::Order.class_eval do

	attr_accessor :gift_code

	money_methods :egift_cards_total

	def has_egift_card?
    line_items.map(&:egift_card).any?
  end

	def activate_egift_cards
		line_items.each do |item|
			if egift_card = item.egift_card
				egift_card.update_columns(purchased_at: Time.now, purchaser_id: user_id)
				Spree::EgiftCardMailer.notification_email(egift_card).deliver_now
				Spree::EgiftCardMailer.copy_notification_email(egift_card, user).deliver_now
			end
		end
		update_column(:shipment_state, 'shipped')
	end



	# Finalizes an in progress order after checkout is complete.
	# Called after transition to complete state when payments will have been processed.
	def debit_egift_cards
		NIDECKER_LOGGER.info "DEBIT EGIFT CARDS"
	  # Record any gift card redemptions.
	  self.adjustments.where(source_type: 'Spree::EgiftCard').each do |adjustment|
	  	NIDECKER_LOGGER.info "adjustment = #{adjustment.inspect}"
	    adjustment.source.debit(adjustment.amount, self)
	  end
	end

	# Tells us if there is the specified gift code already associated with the order
  # regardless of whether or not its currently eligible.
	def egift_credit_exists?(egift_card)
	  adjustments.reload.map(&:source_id).include?(egift_card.id)
	end

	def egift_cards_total
		adjustments.egift_cards.eligible.sum(:amount)
	end

end
Spree::Order.state_machine.after_transition to: :complete, do: :activate_egift_cards
Spree::Order.state_machine.after_transition to: :complete, do: :debit_egift_cards