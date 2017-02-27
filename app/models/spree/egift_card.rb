
module Spree
  class EgiftCard < ActiveRecord::Base

  	UNACTIVATABLE_ORDER_STATES = ["complete", "awaiting_return", "returned"]

  	before_create {generate_token(:code)}

  	belongs_to :purchaser, class_name: 'Spree::User'
  	belongs_to :redeemer, class_name: 'Spree::User'
  	belongs_to :store, class_name: 'Spree::Store'
  	belongs_to :region, class_name: 'Spree::Region'
  	has_many   :transactions, class_name: 'Spree::EgiftCardTransaction'

  	validates :original_value, numericality: { greater_than: 0 }
  	validates_presence_of :message, :recipient_email, :recipient_firstname, :recipient_lastname,
  												:currency, :purchaser_id


  	private

  		# This method will take a column argument so that we can have multiple tokens later if need be.
  		# We check that no other user exists with that token and repeatedly generate another random token while this is true.
  		def generate_token(column)
  		  begin
  		    self[column] = SecureRandom.urlsafe_base64(8)
  		  end while Spree::EgiftCard.exists?(column => self[column])
  		end

  end # EgiftCard
end # Spree