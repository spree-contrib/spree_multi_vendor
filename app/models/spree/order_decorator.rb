module SpreeMultiVendor
  module OrderDecorator
    def self.prepended(base)
      base.state_machine.after_transition to: :complete, do: :send_notification_mails_to_vendors
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
      @vendors = line_items.map { |line_item| line_item.product.vendor }
      @vendors.each do |vendor|
        SpreeMultiVendor::VendorMailer.vendor_notification_email(id, vendor.id).deliver_later
      end
    end
  end
end

Spree::Order.prepend SpreeMultiVendor::OrderDecorator
