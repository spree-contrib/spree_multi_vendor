module SpreeMultiVendor
  module OptionTypeDecorator
    def self.prepended(base)
      base.belongs_to :vendor, required: false
    end
  end
end

Spree::OptionType.prepend SpreeMultiVendor::OptionTypeDecorator
