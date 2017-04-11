Deface::Override.new(
  virtual_path:  'spree/layouts/admin',
  name:          'vendors_main_menu_tab',
  insert_bottom: '#main-sidebar',
  text:       <<-HTML
                <% if can? :admin, Spree::Vendor %>
                  <ul class="nav nav-sidebar">
                    <%= tab plural_resource_name(Spree::Vendor), url: admin_vendors_path, icon: 'money' %>
                  </ul>
                <% end %>
              HTML
)
