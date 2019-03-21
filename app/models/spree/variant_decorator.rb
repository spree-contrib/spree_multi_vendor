Spree::Variant.class_eval do
  before_create :assign_vendor_id
  scope :for_vendor_user, ->(user) { includes(:product).where('spree_products.vendor_id in (?)', user.vendors.ids).references(:product) }

  private

  def assign_vendor_id
    self.vendor_id = product.vendor_id
  end

  def create_stock_items
    Spree:: StockLocation.where(propagate_all_variants: true, vendor_id: vendor_id).each do |stock_location|
      stock_location.propagate_variant(self)
    end
  end
end
