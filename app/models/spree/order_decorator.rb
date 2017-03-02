Spree::Order.class_eval do

	def has_egift_card?
    line_items.map(&:egift_card).any?
  end

	def activate_egift_cards
		line_items.each do |item|
			if egift_card = item.egift_card
				egift_card.update_columns(purchased_at: Time.now, purchaser_id: user_id)
				egift_card.send_email
			end
		end
	end

end
Spree::Order.state_machine.after_transition to: :complete, do: :activate_egift_cards