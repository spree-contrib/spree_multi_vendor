module SpreeMultiVendor
  module VendorModelsDecorator
    def self.prepended(base)
      base.belongs_to :vendor, serializer: ::Spree::V2::Storefront::VendorSerializer
    end
  end
end

%w[StockLocationSerializer ProductSerializer].each do |serializer_name|
  "Spree::V2::Storefront::#{serializer_name}".constantize.prepend(SpreeMultiVendor::VendorModelsDecorator)
end
