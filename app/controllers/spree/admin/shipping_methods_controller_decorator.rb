module Spree::Admin::ShippingMethodsControllerDecorator
  def self.prepended(base)
    base.before_action :set_vendor_id, only: [:create, :update]
  end
end

Spree::Admin::ShippingMethodsController.prepend Spree::Admin::ShippingMethodsControllerDecorator
