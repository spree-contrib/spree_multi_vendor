FactoryGirl.define do
  factory :vendor_user, class: Spree::Vendor do
    user
    vendor
  end
end
