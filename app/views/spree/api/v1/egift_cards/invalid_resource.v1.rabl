object @egift_card
node(:error) { I18n.t(:invalid_resource, :scope => "spree.api") }
node(:errors) { @egift_card.errors.to_hash }
child :egift_card do
	extends "spree/api/v1/egift_cards/egift_card", object: @egift_card
end

