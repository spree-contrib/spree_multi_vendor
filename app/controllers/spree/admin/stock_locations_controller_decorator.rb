module Spree::Admin::StockLocationsControllerDecorator
  def self.prepended(base)
    base.before_action :set_vendor_id, only: [:create, :update]
  end
end

Spree::Admin::StockLocationsController.prepend Spree::Admin::StockLocationsControllerDecorator
