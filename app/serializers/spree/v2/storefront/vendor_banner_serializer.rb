module Spree
  module V2
    module Storefront
      class VendorBannerSerializer < BaseSerializer
        set_type :vendor_banner

        attributes :styles
      end
    end
  end
end
