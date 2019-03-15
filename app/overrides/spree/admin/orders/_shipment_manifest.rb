Deface::Override.new(
    virtual_path: 'spree/admin/orders/_shipment_manifest',
    name: 'filter_shipment_manifest',
    replace: "erb[silent]:contains('shipment.manifest.each do |item|')",
    text: "<% filtered_shipment_manifest =
            if current_spree_vendor
              shipment.manifest.select{|m| m.line_item.product.vendor_id == current_spree_vendor.id}
            else
              shipment.manifest
            end %>
          <% filtered_shipment_manifest.each do |item| %>"
)
