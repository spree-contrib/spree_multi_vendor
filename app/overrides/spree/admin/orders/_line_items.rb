Deface::Override.new(
    virtual_path: 'spree/admin/orders/_line_items',
    name: 'vendorize_line_items',
    replace: "erb[silent]:contains('order.line_items.each do |item|')",
    text: "<% (current_spree_vendor ? order.line_items.for_vendor(current_spree_vendor) : order.line_items).each do |item| %>"
)
