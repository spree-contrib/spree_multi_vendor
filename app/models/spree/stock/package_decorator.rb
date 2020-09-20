module Spree::Stock::PackageDecorator
  def shipping_methods
    vendor = stock_location.vendor
    
    if vendor && Spree::ShippingMethod.method_defined?(:vendor)
      vendor.shipping_methods.to_a
    else
      shipping_categories.map(&:shipping_methods).reduce(:&).to_a
    end
  end
end

Spree::Stock::Package.prepend Spree::Stock::PackageDecorator
