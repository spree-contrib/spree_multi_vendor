module SpreeMultiVendor::Spree::Api::V1::ProductsControllerDecorator
  def self.prepended(base)
    base.before_action only: [:create, :update] do
      set_vendor_id(:product)
    end
  end
end

if SpreeMultiVendor::Engine.api_v1_available?
  Spree::Api::V1::ProductsController.prepend SpreeMultiVendor::Spree::Api::V1::ProductsControllerDecorator
end
