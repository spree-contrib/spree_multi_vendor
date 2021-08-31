module Spree
  module V2
    module Storefront
      class VendorSerializer < BaseSerializer
        set_type :vendor

        attributes :name, :about_us, :slug, :contact_us, :facebook, :twitter, :instagram

        has_one :image, serializer: :vendor_image
        has_one :banner, serializer: :vendor_banner
        has_many :products
      end
    end
  end
end
