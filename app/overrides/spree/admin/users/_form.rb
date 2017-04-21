Deface::Override.new(
  virtual_path: 'spree/admin/users/_form',
  name: 'Add vendor select in user form',
  insert_bottom: 'div[data-hook="admin_user_form_roles"]',
  text: <<-HTML
          <% if current_spree_user.respond_to?(:has_spree_role?) && current_spree_user.has_spree_role?(:admin) %>
            <%= f.field_container :vendor_ids, class: ['form-group'] do %>
              <%= f.label :vendor_ids, Spree.t(plural_resource_name(Spree::Vendor)) %>
              <%= f.collection_select(:vendor_ids, Spree::Vendor.all, :id, :name, { }, { class: 'select2', multiple: true }) %>
            <% end %>
          <% end %>
        HTML
)
