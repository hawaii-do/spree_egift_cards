class CreateEgiftCardTransactions < ActiveRecord::Migration
  def change
    create_table :spree_egift_card_transactions do |t|
      t.decimal :amount, scale: 2, precision: 8
      t.integer :egift_card_id
      t.integer :order_id
    end
  end
end
