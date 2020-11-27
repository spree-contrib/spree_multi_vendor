module SpreeMultiVendor::Spree::Admin::OptionTypesControllerDecorator
  def self.prepended(base)
    base.before_action :set_vendor_id, only: [:create, :update]
  end
end

Spree::Admin::OptionTypesController.prepend SpreeMultiVendor::Spree::Admin::OptionTypesControllerDecorator
