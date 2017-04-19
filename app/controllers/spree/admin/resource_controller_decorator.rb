Spree::Admin::ResourceController.class_eval do
  def set_vendor_id
    if current_spree_user.vendors.any? && (!current_spree_user.respond_to?(:has_spree_role?) || !current_spree_user.has_spree_role?(:admin))
      # TODO: user should have some kind of switcher to select Vendor account
      params[resource.object_name.to_sym][:vendor_id] = current_spree_user.vendors.first.try(:id)
    end
  end
end
