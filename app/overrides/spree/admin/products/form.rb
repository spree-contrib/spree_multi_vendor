Deface::Override.new(
  virtual_path: 'spree/admin/products/_form',
  name: 'Enable vendors to manage product master price',
  replace: 'div[data-hook="admin_product_form_price"]',
  text: <<-HTML
          <%= f.field_container :price, class: ['form-group'] do %>
            <%= f.label :price, raw(Spree.t(:master_price) + content_tag(:span, ' *', class: "required")) %>
            <%= f.text_field :price, value: number_to_currency(@product.price, unit: ''), class: 'form-control', disabled: (cannot? :update, Spree::Price) %>
            <%= f.error_message_on :price %>
          <% end %>
        HTML
)

Deface::Override.new(
    virtual_path: 'spree/admin/products/_form',
    name: 'Enable admin to menage product vendor',
    insert_before: 'div[data-hook="admin_product_form_taxons"]',
    text: <<-HTML
            <% if current_spree_user.respond_to?(:has_spree_role?) && current_spree_user.has_spree_role?(:admin) %>
              <div data-hook="admin_product_form_vendor">
                <%= f.field_container :vendor, class: ['form-group'] do %>
                  <%= f.label :vendor_id, Spree.t(:vendor) %>
                  <%= f.collection_select(:vendor_id, @vendors, :id, :name, { include_blank: Spree.t('match_choices.none') }, { class: 'select2' }) %>
                  <%= f.error_message_on :vendor %>
                <% end %>
              </div>
            <% end %>
          HTML
)
