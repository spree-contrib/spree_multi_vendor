module SpreeMultiVendor::Spree::Api::BaseControllerDecorator
  Spree::Api::BaseController.include(Spree::Api::VendorHelper)

  def self.prepended(base)
    base.helper_method :current_spree_vendor
  end

  private

  def set_vendor_id(resource_name)
    return unless current_spree_vendor

    params[resource_name][:vendor_id] = current_spree_vendor.id
  end
end

::Spree::Api::BaseController.prepend SpreeMultiVendor::Spree::Api::BaseControllerDecorator
