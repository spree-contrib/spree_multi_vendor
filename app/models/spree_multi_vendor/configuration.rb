module SpreeMultiVendor
  class Configuration < Spree::Preferences::Configuration
    DEFAULT_VENDORIZED_MODELS ||= %w[product variant stock_location shipping_method].freeze

   # Some example preferences are shown below, for more information visit:
   # https://guides.spreecommerce.org/developer/core/preferences.html

   preference :vendorized_models, :array, default: DEFAULT_VENDORIZED_MODELS
  end
end
