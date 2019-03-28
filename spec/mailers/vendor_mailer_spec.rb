require 'spec_helper'

describe Spree::VendorMailer, type: :mailer do
  let(:store) { create(:store)}
  let(:vendor) { Spree::Vendor.new(id: 1, name: 'Test vendor', state: 'active', notification_email: 'test-vendor@example.com') }
  let(:other_vendor) { Spree::Vendor.new(id: 2, name: 'Other vendor', state: 'active', notification_email: 'other-vendor@example.com') }
  let(:order) { create(:completed_order_with_totals, line_items_count: 5) }

  context 'vendor notification email' do
    before do
      order.line_items.first.product.update(vendor: vendor)
      order.line_items.last.product.update(vendor: other_vendor)
    end

    it 'is sent from current store email address' do
      notification_email = Spree::VendorMailer.vendor_notification_email(order.id, vendor.id)
      expect(notification_email.from).to have_content(Spree::Store.current.mail_from_address)
    end

    it 'is sent to vendors email address' do
      notification_email = Spree::VendorMailer.vendor_notification_email(order.id, vendor.id)
      expect(notification_email.to).to have_content(vendor.contact_us)
    end

    it 'subject contains order number' do
      notification_email = Spree::VendorMailer.vendor_notification_email(order.id, vendor.id)
      expect(notification_email.subject).to have_content(order.number)
    end

    it 'body contains vendors items' do
      notification_email = Spree::VendorMailer.vendor_notification_email(order.id, vendor.id)
      vendors_item = order.line_items.select { |line_item| line_item.product.vendor == vendor }.first
      expect(notification_email.body.parts.first).to have_text(vendors_item.product.name)
      expect(notification_email.body.parts.last).to have_text(vendors_item.product.name)
    end

    it 'body does not contain other vendors items' do
      notification_email = Spree::VendorMailer.vendor_notification_email(order.id, vendor.id)
      other_vendors_item = order.line_items.select { |line_item| line_item.product.vendor != vendor }.first
      expect(notification_email.body.parts.first).not_to have_text(other_vendors_item.product.name)
      expect(notification_email.body.parts.last).not_to have_text(other_vendors_item.product.name)
    end
  end

end
