Deface::Override.new(
  virtual_path: 'spree/admin/shared/_main_menu',
  name: 'Display configuration tab for vendors',
  replace: 'erb[silent]:contains("current_store")',
  text: '<% if can?(:admin, current_store) || current_spree_user.vendors.any? %>'
)
