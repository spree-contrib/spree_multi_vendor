module Spree
  class VendorMailer < BaseMailer
    def vendor_notification_email(order_id, vendor_id)
      @order = Spree::Order.find(order_id)
      @vendor = Spree::Vendor.find(vendor_id)
      @line_items = @order.line_items.select { |line_item| line_item.product.vendor == @vendor }
      @subtotal = @line_items.sum { |line_item| line_item.price }
      @total = @order.total - (@order.item_total - @subtotal)
      subject = "#{Spree::Store.current.name} #{Spree.t('order_mailer.vendor_notification_email.subject')} ##{@order.number}"
      mail(to: @vendor.contact_us, from: from_address, subject: subject)
    end
  end
end
