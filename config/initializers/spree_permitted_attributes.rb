module Spree
  module PermittedAttributes
    ATTRIBUTES << :vendor_attributes

    mattr_reader *ATTRIBUTES

    @@vendor_attributes = [:name, :about_us, :contact_us, :notification_email, :facebook, :twitter, :instagram]
    @@vendor_attributes << :image if Spree.version.to_f >= 3.6
    @@vendor_attributes << :banner if Spree.version.to_f >= 3.6

    @@product_attributes << :vendor_id if SpreeMultiVendor::Config[:vendorized_models].include?('product')
  end
end
