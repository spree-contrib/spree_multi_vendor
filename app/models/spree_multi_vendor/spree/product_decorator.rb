module SpreeMultiVendor::Spree::ProductDecorator
  def self.prepended(base)
    base.after_destroy :touch_vendor
  end

  Spree::Product.whitelisted_ransackable_associations += %w[vendor]

  private

  def touch_vendor
    vendor&.touch
  end
end

Spree::Product.prepend SpreeMultiVendor::Spree::ProductDecorator
