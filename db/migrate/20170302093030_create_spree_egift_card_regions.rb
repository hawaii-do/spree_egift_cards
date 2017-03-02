class CreateSpreeEgiftCardRegions < ActiveRecord::Migration
  def change
    create_table :spree_egift_card_regions do |t|
      t.integer :region_id, index: true, foreign_key: true
      t.integer :egift_card_id, index: true, foreign_key: true
    end
  end
end
