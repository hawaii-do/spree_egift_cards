class AddPinToEgiftcards < ActiveRecord::Migration
  def change
    add_column :spree_egift_cards, :pin, :bigint, unique: true
  end
end
