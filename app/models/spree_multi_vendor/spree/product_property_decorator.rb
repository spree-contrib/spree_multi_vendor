module SpreeMultiVendor::Spree::ProductPropertyDecorator
  def property_name=(name)
    return super unless Spree::Property.method_defined?(:vendor)

    if name.present?
      # don't use `find_by :name` to workaround globalize/globalize#423 bug
      self.property = Spree::Property
                      .where(name: name, vendor_id: product.try(:vendor_id))
                      .first_or_create(presentation: name)
    end
  end
end

Spree::ProductProperty.prepend SpreeMultiVendor::Spree::ProductPropertyDecorator