class AddColumnsToEgiftCards < ActiveRecord::Migration
  def change
  	change_column :spree_egift_cards, :recipient_firstname, :string, :null =>true
  	change_column :spree_egift_cards, :recipient_lastname, :string, :null =>true
  	change_column :spree_egift_cards, :sender_firstname, :string, :null =>true
  	change_column :spree_egift_cards, :sender_lastname, :string, :null =>true

  	add_column :spree_egift_cards, :recipient_name,:string, :null=>true
  	add_column :spree_egift_cards, :sender_name, :string, :null=>true
  	add_column :spree_egift_cards, :sender_email,:string, :null=>true
  end
end
