Spree::BaseHelper.module_eval do
  def spree_current_vendor
    if current_spree_user.vendors.any? && (!current_spree_user.respond_to?(:has_spree_role?) || !current_spree_user.has_spree_role?(:admin))
      current_spree_user.vendors.first
    end
  end
end
