Deface::Override.new(
    virtual_path: 'spree/layouts/admin',
    name: 'admin_main_menu_add_egift_card_menu_item',
    insert_bottom: '[data-hook="admin_tabs"]',
    text: "<% if can? :admin, current_store %>
    <ul class='nav nav-sidebar'>
      <%= main_menu_tree Spree.t(:egift_cards), icon: 'envelope', sub_menu: 'egift_card', url: '#sidebar-egift-cards' %>
    </ul>
<% end %>"
)