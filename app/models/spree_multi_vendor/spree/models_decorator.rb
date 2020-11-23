module SpreeMultiVendor::Spree::ModelsDecorator
  SpreeMultiVendor.vendorized_models.each do |model|
    model.include Spree::VendorConcern
  end
end
