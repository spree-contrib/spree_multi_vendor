require 'spree/product'
Spree::Product.class_eval do
  add_search_scope :for_vendor do |vendor|
    where('spree_products.vendor_id' => vendor.id)
  end
end
