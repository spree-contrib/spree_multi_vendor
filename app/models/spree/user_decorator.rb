module Spree::UserDecorator
  def self.prepended(base)
    base.has_many :vendor_users, class_name: 'Spree::VendorUser'
    base.has_many :vendors, through: :vendor_users, class_name: 'Spree::Vendor'
  end
end

Spree::User.prepend Spree::UserDecorator
