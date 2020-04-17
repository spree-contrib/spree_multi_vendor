module Spree::VendorDecorator
  def self.prepended(base)
    if defined? (SpreeGlobalize)
      base.translates :name, :about_us, :contact_us, :slug, fallbacks_for_empty_translations: true
    end
  end

  Spree::Vendor.include SpreeGlobalize::Translatable if defined?(SpreeGlobalize)
end
::Spree::Vendor.prepend(Spree::VendorDecorator) if defined? (SpreeGlobalize)
