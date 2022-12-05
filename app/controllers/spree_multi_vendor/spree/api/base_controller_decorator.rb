module SpreeMultiVendor::Spree::Api::BaseControllerDecorator
  Spree::Api::V1::BaseController.include(Spree::Api::VendorHelper) if SpreeMultiVendor::Engine.api_v1_available?

  def self.prepended(base)
    base.helper_method :current_spree_vendor
  end

  private

  def set_vendor_id(resource_name)
    return unless current_spree_vendor

    params[resource_name][:vendor_id] = current_spree_vendor.id
  end
end

::Spree::Api::V1::BaseController.prepend SpreeMultiVendor::Spree::Api::BaseControllerDecorator if SpreeMultiVendor::Engine.api_v1_available?
