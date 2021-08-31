Deface::Override.new(
  virtual_path:  'spree/shared/_link_to_account',
  name:          'Add Vendor Panel button to frontend',
  replace: 'erb[loud]:contains("nav_bar.admin_panel")',
  text:<<-HTML
  		<% if try_spree_current_user.has_spree_role?(:admin) %>
  			<%= link_to Spree.t('nav_bar.admin_panel'), spree.admin_orders_path(locale: nil), class: 'dropdown-item text-uppercase'%>
  		<% elsif  try_spree_current_user.vendors.any?%>
			<%= link_to "Vendor Panel", spree.admin_orders_path(locale: nil), class: 'dropdown-item text-uppercase'%>  		
  		<% end %>
    HTML
    )