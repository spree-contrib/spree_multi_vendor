module Spree
  module Admin
    module VendorHelper
      def current_spree_vendor
        if current_spree_user.vendors.any? && (!current_spree_user.respond_to?(:has_spree_role?) || !current_spree_user.has_spree_role?(:admin))
          current_spree_user.vendors.first
        end
      end

      def vendor_state_options
        @vendor_state_options ||= Spree::Vendor.state_machines[:state].states.collect { |s| [Spree.t("vendor_states.#{s.name}"), s.value] }
      end

      def vendor_tabs
        Rails.application.config.spree_backend.tabs[:vendor]
      end
    end
  end
end
