Deface::Override.new(
    virtual_path: 'spree/admin/shared/_order_summary',
    name: 'display_vendor_subtotal',
    replace: "erb[loud]:contains('@order.display_item_total.to_html')",
    text: "<%= current_spree_vendor ? @order.display_vendor_subtotal(current_spree_vendor).to_html : @order.display_item_total.to_html %>"
)

Deface::Override.new(
    virtual_path: 'spree/admin/shared/_order_summary',
    name: 'display_vendor_ship_total',
    replace: "erb[loud]:contains('@order.display_ship_total.to_html')",
    text: "<%= current_spree_vendor ? @order.display_vendor_ship_total(current_spree_vendor).to_html : @order.display_ship_total.to_html %>"
)

Deface::Override.new(
    virtual_path: 'spree/admin/shared/_order_summary',
    name: 'display_vendor_total',
    replace: "erb[loud]:contains('@order.display_total.to_html')",
    text: "<%= current_spree_vendor ? @order.display_vendor_total(current_spree_vendor).to_html : @order.display_total.to_html %>"
)
