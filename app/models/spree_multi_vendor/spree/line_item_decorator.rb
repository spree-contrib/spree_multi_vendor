module SpreeMultiVendor::Spree::LineItemDecorator
  def self.prepended(base)
    base.scope :for_vendor, ->(vendor) do
      if ::Spree::LineItem.reflect_on_association(:vendor)
        where(vendor_id: vendor.id)
      elsif ::Spree::Product.reflect_on_association(:vendor)
        joins(variant: :product).where('spree_products.vendor_id' => vendor.id)
      elsif ::Spree::Variant.reflect_on_association(:vendor)
        joins(:variant).where('spree_variants.vendor_id' => vendor.id)
      else
        none
      end
    end
    base.scope :not_for_vendor, ->(vendor) do
      if ::Spree::Product.reflect_on_association(:vendor)
        where.not(vendor_id: vendor.id)
      elsif ::Spree::Product.reflect_on_association(:vendor)
        joins(variant: :product).where.not('spree_products.vendor_id' => vendor.id)
      elsif ::Spree::Variant.reflect_on_association(:vendor)
        joins(:variant).where.not('spree_variants.vendor_id' => vendor.id)
      else
        none
      end
    end
  end

  def vendor
    @vendor ||= if self.class.reflect_on_association(:vendor) && self[:vendor_id].present?
                  ::Spree::Vendor.unscoped.find(self[:vendor_id])
                elsif product.class.reflect_on_association(:vendor) && product.vendor_id.present?
                  product.vendor
                elsif variant.class.reflect_on_association(:vendor) && variant.vendor_id.present?
                  variant.vendor
                end
  end

  def vendor_id
    @vendor_id ||= if self.class.reflect_on_association(:vendor) && self[:vendor_id].present?
                    self[:vendor_id]
                   elsif product.class.reflect_on_association(:vendor) && product.vendor_id.present?
                     product.vendor_id
                   elsif variant.class.reflect_on_association(:vendor) && variant.vendor_id.present?
                     variant.vendor_id
                   end
  end
end

Spree::LineItem.prepend SpreeMultiVendor::Spree::LineItemDecorator
