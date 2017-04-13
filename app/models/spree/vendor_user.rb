module Spree
  class VendorUser < Spree::Base
    belongs_to :vendor, class_name: Spree::Vendor
    belongs_to :user, class_name: Spree.user_class

    validates :vendor_id, uniqueness: { scope: :user_id }
  end
end
