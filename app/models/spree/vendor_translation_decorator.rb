module Spree::VendorDecorator
  if defined? (SpreeGlobalize)
    def self.prepended(base)
      base.translates :name, :about_us, :contact_us, :slug, fallbacks_for_empty_translations: true
    end

    Spree::Vendor.include SpreeGlobalize::Translatable
  end
end

::Spree::Vendor.prepend(Spree::VendorDecorator)