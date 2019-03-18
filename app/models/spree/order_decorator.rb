module SpreeMultiVendor
  module OrderDecorator
    def self.prepended(base)
      base.has_many :commissions, class_name: 'Spree::OrderCommission'
      base.state_machine.after_transition to: :complete, do: :generate_order_commissions
      base.state_machine.after_transition to: :complete, do: :send_notification_mails_to_vendors
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

    def send_notification_mails_to_vendors
      vendor_ids = line_items.map { |line_item| line_item.product.vendor_id }
      vendor_ids.each do |vendor_id|
        Spree::VendorMailer.vendor_notification_email(id, vendor_id).deliver_later
      end
    end
  end
end

Spree::Order.prepend SpreeMultiVendor::OrderDecorator
