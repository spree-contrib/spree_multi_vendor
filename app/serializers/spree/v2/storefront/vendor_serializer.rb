module Spree
  module V2
    module Storefront
      class VendorSerializer < BaseSerializer
        set_type :vendor

        attributes :name, :about_us, :slug, :contact_us

        has_one :image, serializer: :vendor_image
        has_many :products
      end
    end
  end
end
