Deface::Override.new(
  virtual_path: 'spree/admin/shared/_main_menu',
  name: 'Display configuration tab for vendors',
  replace: 'erb[silent]:contains("current_store")',
  text: '<% if can?(:admin, current_store) || current_spree_user&.vendors&.any? %>'
)
Deface::Override.new(
  virtual_path:  'spree/admin/shared/_main_menu',
  name:          'vendors_main_menu_tabs',
  insert_bottom: 'nav',
  text:       <<-HTML
                <% if current_spree_user.respond_to?(:has_spree_role?) && current_spree_user.has_spree_role?(:admin) %>
                  <ul class="nav nav-sidebar border-bottom">
                    <%= tab plural_resource_name(Spree::Vendor), url: admin_vendors_path, icon: 'money' %>
                  </ul>
                <% end %>
                <% if defined?(current_spree_vendor) && current_spree_vendor %>
                  <ul class="nav nav-sidebar border-bottom">
                    <%= tab Spree::Vendor.model_name.human, url: admin_vendor_settings_path, icon: 'money' %>
                  </ul>
                <% end %>
HTML
)
