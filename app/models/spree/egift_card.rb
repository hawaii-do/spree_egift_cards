
module Spree
  class EgiftCard < ActiveRecord::Base

  	before_create {generate_token(:code)}

  	belongs_to :purchaser, class_name: 'Spree::User'
  	belongs_to :redeemer, class_name: 'Spree::User'
  	belongs_to :store, class_name: 'Spree::Store'
  	# belongs_to :region, class_name: 'Spree::Region'
    belongs_to :tax_category, class_name: 'Spree::TaxCategory'
    belongs_to :order, class_name: 'Spree::Order'
    belongs_to :line_item, class_name: 'Spree::LineItem'

  	has_many :transactions, class_name: 'Spree::EgiftCardTransaction'
    has_many :egift_card_regions
    has_many :regions, through: :egift_card_regions, class_name: 'Spree::Region'

  	validates :original_value, numericality: { greater_than: 0 }
  	validates_presence_of :message, :recipient_email, :recipient_firstname, :recipient_lastname,
  												:currency

    scope :by_store, lambda { |store| where(:store_id => store.id) }

    def active?
      !purchased_at.nil?
    end

    def send_email
      logger.info "SEND EMAIL"
    end

    def name
      'EgiftCard'
    end

    def description
      'A convenient and flexible way to share products with family and friends.'
    end

    def images
      []
    end

    def small_image

    end

    def variant_images
      []
    end

    def master
      Spree::Variant.find_by_sku(code)
    end

    def variant_ids
      [master.id]
    end

    def debit(amount, order)
      raise 'Cannot debit gift card by amount greater than current value.' if (self.current_value - amount.to_f.abs) < 0
      transaction = self.transactions.build
      transaction.amount = amount
      transaction.order  = order
      self.current_value = self.current_value - amount.abs
      self.save
    end

    # def tax_category
    #   Spree::TaxCategory.where(name: 'E-Gift Card', store_id: store_id).first
    # end

    def shipping_category
      Spree::ShippingCategory.where(name: 'E-Gift Card', store_id: store_id).first
    end

  	private

  		# This method will take a column argument so that we can have multiple tokens later if need be.
  		# We check that no other user exists with that token and repeatedly generate another random token while this is true.
  		def generate_token(column)
  		  begin
  		    self[column] = SecureRandom.hex(6).upcase
  		  end while Spree::EgiftCard.exists?(column => self[column])
  		end

  end # EgiftCard
end # Spree