module Spree
  module V2
    module Storefront
      class VendorSerializer < BaseSerializer
        set_type :vendor

        attributes :name, :about_us
      end
    end
  end
end
