require 'spec_helper'

describe Spree::VendorOrderTotals do
  let(:vendor) { create(:vendor) }
  let(:order) { create(:completed_order_with_totals, line_items_count: 6, line_items_price: 100, shipment_cost: 50) }
  let!(:shipment) { create(:shipment, order: order, cost: 20, stock_location: vendor.stock_locations.first) }
  let!(:promotion) { create(:promotion_with_item_adjustment, adjustment_rate: 10, code: '10off') }

  subject { described_class.new(order: order, vendor: vendor) }

  before do
    order.products.update_all(vendor_id: vendor.id)
    order.vendor_line_items(vendor).update_all(additional_tax_total: 10)
    order.vendor_line_items(vendor).update_all(included_tax_total: 5)
    order.coupon_code = '10off'
    Spree::PromotionHandler::Coupon.new(order).apply
    order.reload
  end

  Spree::VendorOrderTotals::METHOD_NAMES.each do |method_name|
    describe "##{method_name}" do
      it { expect(subject.send(method_name)).to eq(order.send("vendor_#{method_name}", vendor)) }
    end

    describe "#display_#{method_name}" do
      it { expect(subject.send("display_#{method_name}")).to eq(order.send("display_vendor_#{method_name}", vendor)) }
    end
  end

  describe '#item_count' do
    it { expect(subject.item_count).to eq(order.vendor_item_count(vendor)) }
  end
end
