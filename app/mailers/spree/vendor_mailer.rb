module Spree
  class VendorMailer < ::Spree::BaseMailer
    def vendor_notification_email(order_id, vendor_id)
      @vendor = Spree::Vendor.find(vendor_id)
      return unless @vendor.notification_email.present?

      @order = Spree::Order.find(order_id)
      @line_items = @order.line_items.for_vendor(@vendor)
      @subtotal = @order.vendor_subtotal(@vendor)
      @total = @order.vendor_total(@vendor)
      subject = "#{Spree::Store.current.name} #{Spree.t('order_mailer.vendor_notification_email.subject')} ##{@order.number}"
      mail(to: @vendor.notification_email, from: from_address, subject: subject)
    end
  end
end
