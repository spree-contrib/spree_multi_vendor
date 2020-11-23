module SpreeMultiVendor::Spree::Admin::PropertiesControllerDecorator
  def self.prepended(base)
    base.before_action :set_vendor_id, only: [:create, :update]
  end
end

Spree::Admin::PropertiesController.prepend SpreeMultiVendor::Spree::Admin::PropertiesControllerDecorator
