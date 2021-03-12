module Spree
  module Api
    module VendorHelper
      def current_spree_vendor
        if current_api_user.vendors.any? && (!current_api_user.respond_to?(:has_spree_role?) || !current_api_user.has_spree_role?(:admin))
          current_api_user.vendors.first
        end
      end
    end
  end
end
