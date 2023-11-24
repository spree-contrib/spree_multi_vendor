require 'spec_helper'

describe Spree::V2::Storefront::VendorOrderTotalsSerializer do
  let(:vendor) { create(:vendor, name: 'Test', about_us: 'Hello World') }
  let(:order) { create(:completed_order_with_totals, line_items_count: 6, line_items_price: 100, shipment_cost: 50) }
  let!(:shipment) { create(:shipment, order: order, cost: 20, pre_tax_amount: 20, stock_location: vendor.stock_locations.first) }
  let!(:promotion) { create(:promotion_with_item_adjustment, adjustment_rate: 10, code: '10off') }

  let(:vendor_order_totals) { Spree::VendorOrderTotals.new(order: order, vendor: vendor) }

  before do
    order.products.update_all(vendor_id: vendor.id)
    order.vendor_line_items(vendor).update_all(additional_tax_total: 10)
    order.vendor_line_items(vendor).update_all(included_tax_total: 5)
    order.vendor_shipments(vendor).update_all(adjustment_total: 5)
    order.vendor_line_items(vendor).update_all(promo_total: 10)
  end

  subject { described_class.new(vendor_order_totals) }

  let(:expected_hash) do
    {
      data: {
        id: vendor.id.to_s,
        type: :vendor_totals,
        attributes: {
          name: 'Test',
          additional_tax_total: BigDecimal(60),
          display_additional_tax_total: Spree::Money.new(60),
          included_tax_total: BigDecimal(30),
          display_included_tax_total: Spree::Money.new(30),
          ship_total: BigDecimal(25),
          display_ship_total: Spree::Money.new(25),
          subtotal: BigDecimal(600),
          display_subtotal: Spree::Money.new(600),
          promo_total: BigDecimal(60),
          display_promo_total: Spree::Money.new(60),
          total: BigDecimal(625),
          display_total: Spree::Money.new(625),
          item_count: 6,
          pre_tax_item_amount: BigDecimal(600),
          display_pre_tax_item_amount: Spree::Money.new(600),
          pre_tax_ship_amount: BigDecimal(20),
          display_pre_tax_ship_amount: Spree::Money.new(20),
          pre_tax_total: BigDecimal(620),
          display_pre_tax_total: Spree::Money.new(620)
        }
      }
    }
  end

  it { expect(subject.serializable_hash).to be_kind_of(Hash) }
  it { expect(subject.serializable_hash).to eq(expected_hash) }
end
