module SpreeMultiVendor
  module SerializerDecorator
    def self.prepended(base)
      base.belongs_to :vendor, serializer: ::Spree::V2::Storefront::VendorSerializer
    end
  end
end

SpreeMultiVendor.vendorized_models.each do |model|
  serializer_class_name = "Spree::V2::Storefront::#{model.to_s.demodulize}Serializer".constantize

  serializer_class_name.prepend(SpreeMultiVendor::SerializerDecorator)
rescue
end

# Variant model accesses Vendor via Product if not associated directly
unless SpreeMultiVendor.vendorized_models.include?(Spree::Variant)
  Spree::V2::Storefront::VariantSerializer.prepend(SpreeMultiVendor::SerializerDecorator)
end

unless SpreeMultiVendor.vendorized_models.include?(Spree::LineItem)
  Spree::V2::Storefront::LineItemSerializer.prepend(SpreeMultiVendor::SerializerDecorator)
end
