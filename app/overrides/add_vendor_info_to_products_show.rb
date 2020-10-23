Deface::Override.new(
  virtual_path: 'spree/products/show',
  name: 'show_vendor_info',
  insert_top: 'div[data-hook="product_right_part"]',
  partial: 'spree/products/vendor_info',
  original: '47353a0c48e2c390e1b5dc9afe9a8438589aa340'
)
