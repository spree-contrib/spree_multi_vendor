module Spree::ProductsControllerDecorator
  Spree::ProductsController.include(SpreeMultiVendor::MultiVendorHelpers)

  def self.prepended(base)
    base.helper_method :filtering_params
  end
end

Spree::ProductsController.prepend Spree::ProductsControllerDecorator
