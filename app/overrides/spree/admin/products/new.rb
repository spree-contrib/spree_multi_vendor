Deface::Override.new(
    virtual_path: 'spree/admin/products/new',
    name: 'Enable admin to create products with assigned vendor',
    insert_after: 'div[data-hook="new_product_shipping_category"]',
    text: <<-HTML
            <% if current_spree_user.respond_to?(:has_spree_role?) && current_spree_user.has_spree_role?(:admin) %>
              <div data-hook="new_product_vendor" class="col-12 col-md-4">
                <%= f.field_container :vendor, class: ['form-group'] do %>
                  <%= f.label :vendor_id, Spree.t(:vendor) %>
                  <%= f.collection_select(:vendor_id, @vendors, :id, :name, { include_blank: Spree.t('match_choices.none') }, { class: 'select2' }) %>
                  <%= f.error_message_on :vendor %>
                <% end %>
              </div>
            <% end %>
    HTML
)
