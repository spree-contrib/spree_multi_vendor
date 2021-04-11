class VendorNotificationPreview < ActionMailer::Preview
  def vendor_notification_email
    Spree::VendorMailer.vendor_notification_email(Spree::Order.complete.first.id, Spree::Vendor.first.id)
  end
end
