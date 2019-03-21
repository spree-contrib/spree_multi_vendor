Deface::Override.new(
  virtual_path: 'spree/admin/properties/index',
  name: 'remove_conditions',
  remove: "erb[silent]:contains('if current_spree_user.respond_to?(:has_spree_role?) && current_spree_user.has_spree_role?(:admin)')"
)

Deface::Override.new(
  virtual_path: 'spree/admin/properties/index',
  name: 'check_first_vendor_name',
  insert_before: '.row:last-of-type',
  text: '<% if current_spree_user.respond_to?(:has_spree_role?) && current_spree_user.has_spree_role?(:admin) && params[:vendor_name_not_null] %>'
)

Deface::Override.new(
  virtual_path: 'spree/admin/properties/index',
  name: 'check_second_vendor_name',
  insert_before: 'tr[data-hook="listing_properties_header"] th:nth-child(3)',
  text: '<% if current_spree_user.respond_to?(:has_spree_role?) && current_spree_user.has_spree_role?(:admin) && params[:vendor_name_not_null] %>'
)

Deface::Override.new(
  virtual_path: 'spree/admin/properties/index',
  name: 'check_third_vendor_name',
  insert_before: 'tr[data-hook="listing_properties_row"] td:nth-child(3)',
  text: '<% if current_spree_user.respond_to?(:has_spree_role?) && current_spree_user.has_spree_role?(:admin) && property.respond_to?(:vendor) %>'
)
