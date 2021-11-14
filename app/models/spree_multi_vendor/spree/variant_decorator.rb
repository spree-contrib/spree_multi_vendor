module SpreeMultiVendor::Spree::VariantDecorator
  def self.prepended(base)
    base.before_create :assign_vendor

    base.scope :for_vendor_user, ->(user) { where(vendor_id: user.vendor_ids) }
  end

  def vendor
    @vendor ||= if self.class.reflect_on_association(:vendor) && self[:vendor_id].present?
                  ::Spree::Vendor.unscoped.find(self[:vendor_id])
                elsif Spree::Product.reflect_on_association(:vendor) && product.vendor_id.present?
                  product.vendor
                end
  end

  def vendor_id
    @vendor_id ||= if self.class.reflect_on_association(:vendor) && self[:vendor_id].present?
                     self[:vendor_id]
                   elsif Spree::Product.reflect_on_association(:vendor) && product.vendor_id.present?
                     product.vendor_id
                   end
  end

  private

  def assign_vendor
    return if !product.class.reflect_on_association(:vendor) || product.vendor.blank?
    return if !self.class.reflect_on_association(:vendor) || self[:vendor_id].present?

    self.vendor = product.vendor
  end

  def create_stock_items
    Spree::StockLocation.where(propagate_all_variants: true, vendor_id: vendor_id).each do |stock_location|
      stock_location.propagate_variant(self)
    end
  end
end

Spree::Variant.prepend SpreeMultiVendor::Spree::VariantDecorator
