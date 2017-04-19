Spree.user_class.class_eval do
  has_many :vendor_users, class_name: Spree::VendorUser
  has_many :vendors, through: :vendor_users, class_name: Spree::Vendor
end
