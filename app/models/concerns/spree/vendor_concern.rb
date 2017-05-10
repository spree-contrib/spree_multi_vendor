module Spree
  module VendorConcern
    extend ActiveSupport::Concern

    included do
      belongs_to :vendor, class_name: Spree::Vendor

      scope :with_vendor, ->(vendor_id) { where(vendor_id: vendor_id) }
    end
  end
end
