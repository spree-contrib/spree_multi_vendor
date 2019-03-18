module SpreeMultiVendor
  module OrderDecorator
    def self.prepended(base)
      base.has_many :commissions, class_name: 'Spree::OrderCommission'
      base.state_machine.after_transition to: :complete, do: :generate_order_commissions
    end

    def generate_order_commissions
      Spree::Orders::GenerateCommissions.call(self)
    end

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
