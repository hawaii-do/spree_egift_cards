module Spree
	class EgiftCardMailer < BaseMailer
		def notification_email(egift_card)
			@egift_card = egift_card
			mail(to: @egift_card.recipient_email, subject: "You have receive an Egift Card!")
		end
	end
end