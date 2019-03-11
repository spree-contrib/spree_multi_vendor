Spree::Product.class_eval do
  after_destroy :touch_vendor

  self.whitelisted_ransackable_associations += %w[vendor]

  private

  def touch_vendor
    vendor&.touch
  end
end
