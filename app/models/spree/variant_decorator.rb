Spree::Variant.class_eval do
  before_create :assign_vendor_id

  private

  def assign_vendor_id
    self.vendor_id = product.vendor_id
  end
end
