Spree::Admin::ResourceController.class_eval do
  def set_vendor_id
    return unless current_spree_vendor
    params[resource.object_name.to_sym][:vendor_id] = current_spree_vendor.id
  end
end
