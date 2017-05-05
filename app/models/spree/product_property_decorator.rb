Spree::ProductProperty.class_eval do
  attr_accessor :vendor_id

  before_validation :set_vendor_id, unless: proc { property.vendor_id }

  scope :with_vendor, -> (vendor_id) { joins(:property).where(spree_properties: { vendor_id: vendor_id }) }
  scope :with_name, -> (name) { joins(:property).where(spree_properties: { name: name }) }

  private

  def set_vendor_id
    property.update(vendor_id: vendor_id)
  end
end
