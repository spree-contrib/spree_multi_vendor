module SpreeMultiVendor::Spree::Admin::ResourceControllerDecorator
  def set_vendor_id
    return unless current_spree_vendor
    params[resource.object_name.to_sym][:vendor_id] = current_spree_vendor.id
  end
end

Spree::Admin::ResourceController.prepend SpreeMultiVendor::Spree::Admin::ResourceControllerDecorator
