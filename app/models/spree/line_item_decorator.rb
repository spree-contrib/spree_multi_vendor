Spree::LineItem.class_eval do
  scope :for_vendor, ->(vendor) { includes(:product).where('spree_products.vendor_id' => vendor.id) }
end
