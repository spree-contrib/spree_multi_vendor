module SpreeMultiVendor::Spree::LineItemDecorator
  def self.prepended(base)
    base.scope :for_vendor, ->(vendor) { includes(:product).where('spree_products.vendor_id' => vendor.id) }
    base.scope :not_for_vendor, ->(vendor) { includes(:product).where.not('spree_products.vendor_id' => vendor.id) }
  end
end

Spree::LineItem.prepend SpreeMultiVendor::Spree::LineItemDecorator
