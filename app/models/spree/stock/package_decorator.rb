module Spree::Stock::PackageDecorator
  def shipping_methods
    if (vendor = stock_location.vendor)
      vendor.shipping_methods.to_a
    else
      shipping_categories.map(&:shipping_methods).reduce(:&).to_a
    end
  end
end

Spree::Stock::Package.prepend Spree::Stock::PackageDecorator
