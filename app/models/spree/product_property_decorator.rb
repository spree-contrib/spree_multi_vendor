
module Spree::ProductPropertyDecorator
  def self.prepended(base)
    base.attr_accessor :vendor_id

    base.before_validation :set_vendor_id, unless: proc { property.vendor_id }

    base.scope :with_vendor, -> (vendor_id) { joins(:property).where(spree_properties: { vendor_id: vendor_id }) }
    base.scope :with_name, -> (name) { joins(:property).where(spree_properties: { name: name }) }
  end
  
  def property_name=(name)
    return super unless Spree::Property.method_defined?(:vendor)

    if name.present?
      # don't use `find_by :name` to workaround globalize/globalize#423 bug
      self.property = Spree::Property
                      .where(name: name, vendor_id: product.try(:vendor_id))
                      .first_or_create(presentation: name)
    end
  end
    
  private

  def set_vendor_id
    property.update(vendor_id: vendor_id)
  end
end

Spree::ProductProperty.prepend Spree::ProductPropertyDecorator