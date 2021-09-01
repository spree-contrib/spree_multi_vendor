module Spree
  module V2
    module Storefront
      class VendorImageSerializer < BaseSerializer
        set_type :vendor_image

        attributes :styles, :original_url
      end
    end
  end
end
