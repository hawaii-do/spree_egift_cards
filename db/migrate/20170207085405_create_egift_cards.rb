class CreateEgiftCards < ActiveRecord::Migration
  def change
    create_table :spree_egift_cards do |t|
      t.text :message                   , null: false
      t.string :code                    , null: false
      t.string :recipient_email         , null: false
      t.string :recipient_firstname     , null: false
      t.string :recipient_lastname      , null: false
      t.string :sender_firstname
      t.string :sender_lastname
      t.decimal :current_value          , null: false, precision: 8, scale: 2
      t.decimal :original_value         , null: false, precision: 8, scale: 2
      t.string :currency                , null: false
      t.integer :purchaser_id           , null: false
      t.integer :redeemer_id
      t.integer :line_item_id
      t.integer :store_id
      t.integer :region_id
      t.datetime :send_at
      t.datetime :redeemed_at
      t.timestamps
    end
  end
end
