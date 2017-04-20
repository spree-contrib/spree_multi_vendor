Spree::Product.class_eval do
  belongs_to :vendor, class_name: Spree::Vendor
end
