Spree::Admin::BaseController.class_eval do
  include Spree::Admin::VendorHelper 
  helper_method :current_spree_vendor
end
