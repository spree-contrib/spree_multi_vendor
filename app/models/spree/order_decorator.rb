module SpreeMultiVendor
  module OrderDecorator
    def display_vendor_subtotal(vendor)
      Spree::Money.new(vendor_subtotal(vendor), { currency: currency })
    end

    def display_vendor_total(vendor)
      Spree::Money.new(vendor_total(vendor), { currency: currency })
    end

    def vendor_subtotal(vendor)
      line_items.for_vendor(vendor).sum(:pre_tax_amount)
    end

    def vendor_total(vendor)
      total - line_items.not_for_vendor(vendor).sum(:pre_tax_amount)
    end
  end
end

Spree::Order.prepend SpreeMultiVendor::OrderDecorator
