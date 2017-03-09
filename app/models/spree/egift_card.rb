
module Spree
  class EgiftCard < ActiveRecord::Base

  	before_create {generate_token(:code)}

  	belongs_to :purchaser, class_name: 'Spree::User'
  	belongs_to :redeemer, class_name: 'Spree::User'
  	belongs_to :store, class_name: 'Spree::Store'
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

    # include Spree::CalculatedAdjustments

    UNACTIVATABLE_ORDER_STATES = ["complete", "awaiting_return", "returned"]

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

    def active?
      !purchased_at.nil?
    end

    def send_email
      logger.info "SEND EMAIL"
    end

    def name
      'Egift Card'
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

    # Calculate amount for adjustment.
    def compute_amount(order)
      credits = order.adjustments.select{|a|a.amount < 0 && a.source_type != 'Spree::GiftCard'}.map(&:amount).sum
      [(order.item_total + order.ship_total + order.additional_tax_total + credits), current_value].min * -1
    end

    # Create a transaction and reduce the current value by order amount.
    def debit(amount, order)
      raise 'Cannot debit gift card by amount greater than current value.' if (self.current_value - amount.to_f.abs) < 0
      transaction = self.transactions.build
      transaction.amount = amount
      transaction.order  = order
      self.current_value = self.current_value - amount.abs
      self.save
    end

    # Apply egift card when checkout is updated and creates an adjustment.
    def apply(order)
      # Nothing to do if the gift card is already associated with the order
      return if order.egift_credit_exists?(self)
      order.update!
      adj = Spree::Adjustment.create!(
            amount: compute_amount(order),
            order: order,
            adjustable: order,
            source: self,
            mandatory: true,
            label: "#{Spree.t(:egift_card)}"
          )
      order.update!
    end

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