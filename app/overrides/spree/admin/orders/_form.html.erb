Deface::Override.new(
    virtual_path: 'spree/admin/orders/_form',
    name: 'vendorize_shipments',
    replace: "erb[loud]:contains('render partial: \"spree/admin/orders/shipment\", collection: @order.shipments.order(:created_at), locals: {order: order}')",
    text: "<%= render partial: \"spree/admin/orders/shipment\", collection: (current_spree_vendor ? @order.shipments.for_vendor(current_spree_vendor).order(:created_at) : @order.shipments.order(:created_at)), locals: {order: order} %>"
)

Deface::Override.new(
    virtual_path: 'spree/admin/orders/_form',
    name: 'display_vendor_total',
    replace: "erb[loud]:contains('order.display_total')",
    text: "<%= current_spree_vendor ? order.display_vendor_total(current_spree_vendor).to_html : order.display_total.to_html %>"
)
