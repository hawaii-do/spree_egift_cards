class AddReceiveCopyToSpreeEgiftCards < ActiveRecord::Migration
  def change
  	add_column :spree_egift_cards, :receive_copy, :int
  end
end
