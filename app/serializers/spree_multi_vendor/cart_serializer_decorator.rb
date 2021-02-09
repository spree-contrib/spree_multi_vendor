module SpreeMultiVendor
  module CartSerializerDecorator
    def self.prepended(base)
      base.has_many :vendors,
                    serializer: ::Spree::V2::Storefront::VendorSerializer,
                    record_type: :vendor,
                    id_method_name: :vendor_ids,
                    object_method_name: :vendor_list

      base.has_many :vendor_totals,
                    serializer: ::Spree::V2::Storefront::VendorOrderTotalsSerializer,
                    record_type: :vendor_totals,
                    id_method_name: :vendor_ids,
                    object_method_name: :vendor_totals
    end
  end
end

Spree::V2::Storefront::CartSerializer.prepend(SpreeMultiVendor::CartSerializerDecorator)
