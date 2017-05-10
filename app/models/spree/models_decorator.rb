SpreeMultiVendor.vendorized_models.each do |model|
  model.class_eval do
    include Spree::VendorConcern
  end
end
