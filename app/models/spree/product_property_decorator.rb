Spree::ProductProperty.class_eval do
  attr_accessor :vendor_id

  before_validation :set_vendor_id, unless: proc { property.vendor_id }

  private

  def set_vendor_id
    property.update(vendor_id: vendor_id)
  end
end
