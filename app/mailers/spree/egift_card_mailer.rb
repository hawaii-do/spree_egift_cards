module Spree
	class EgiftCardMailer < BaseMailer
		def notification_email(egift_card)
			@egift_card = egift_card
			mail(to: @egift_card.recipient_email, subject: "You have received an Egift Card!", from: from_address)
		end

		def copy_notification_email(egift_card,user)
			@egift_card = egift_card
			mail(to: (egift_card.sender_email || user.email), subject: "You have sent an Egift Card", from: from_address )
		end
	end
end