require 'spec_helper'

describe Spree::Order do
  let(:vendor) { create(:vendor, name: 'Vendor 1') }
  let(:vendor_2) { create(:vendor, name: 'Vendor 2') }

  let(:order) { create(:order_with_line_items, state: 'payment', line_items_count: 6, line_items_price: 100, shipment_cost: 50) }

  before do
    order.line_items.each_with_index do |li, idx|
      product = li.product
      product.vendor = idx.odd? ? vendor : vendor_2
      product.save
    end
  end

  context 'associations' do
    it { is_expected.to have_many(:commissions) }
  end

  context 'complete with spree_multi_vendor' do
    before { allow(order).to receive_messages payment_required?: false }

    it 'generates commission records' do
      expect do
        order.next!
        order.reload
      end.to change { Spree::OrderCommission.count }.by(2).and change { vendor.commissions.count }.by(1)
                                                          .and change { vendor_2.commissions.count }.by(1)

      order.line_items.includes(product: :vendor).group_by { |li| li.product.vendor }.each do |v, line_items|
        commission_ammount = v.commission_rate * line_items.pluck(:pre_tax_amount).sum.to_f / 100

        expect(v.commissions.sum(:amount)).to eq(commission_ammount)
      end
    end

    it 'sends mails only once per vendor' do
      mail_double_1 = double(:mail_double_1)
      mail_double_2 = double(:mail_double_1)

      expect(Spree::VendorMailer).to receive(:vendor_notification_email)
        .with(be_an(Integer), vendor.id) { mail_double_1 }
      expect(mail_double_1).to receive(:deliver_later)
      expect(Spree::VendorMailer).to receive(:vendor_notification_email)
        .with(be_an(Integer), vendor_2.id) { mail_double_2 }
      expect(mail_double_2).to receive(:deliver_later)

      order.next!
    end
  end

  context 'vendor methods' do
    let!(:shipment) { create(:shipment, order: order, cost: 20, pre_tax_amount: 20, stock_location: vendor.stock_locations.first) }
    let!(:promotion) { create(:promotion_with_item_adjustment, adjustment_rate: 10, code: '10off') }

    before do
      order.coupon_code = '10off'
      Spree::PromotionHandler::Coupon.new(order).apply
      order.reload
    end

    describe '#vendor_line_items' do
      it { expect(order.vendor_line_items(vendor)).to eq(order.line_items.for_vendor(vendor)) }
      it { expect(order.vendor_line_items(vendor).count).to eq(3) }
    end

    describe '#vendor_shipments' do
      it { expect(order.vendor_shipments(vendor).to_a).to eq([shipment]) }
      it { expect(order.vendor_shipments(vendor).count).to eq(1) }
    end

    describe '#vendor_subtotal' do
      it { expect(order.vendor_subtotal(vendor)).to eq(270) }
    end

    describe '#display_subtotal' do
      it { expect(order.display_vendor_subtotal(vendor).to_s).to eq('$270.00') }
    end

    describe '#vendor_pre_tax_item_amount' do
      it { expect(order.vendor_pre_tax_item_amount(vendor)).to eq(300) }
    end

    describe '#displayvendor_pre_tax_item_amount' do
      it { expect(order.display_vendor_pre_tax_item_amount(vendor).to_s).to eq('$300.00') }
    end

    describe '#vendor_pre_tax_total' do
      it { expect(order.vendor_pre_tax_total(vendor)).to eq(320) }
    end

    describe '#displayvendor_pre_tax_total' do
      it { expect(order.display_vendor_pre_tax_total(vendor).to_s).to eq('$320.00') }
    end

    context 'ship total' do
      before do
        order.vendor_shipments(vendor).update_all(adjustment_total: 5)
      end

      describe '#vendor_ship_total' do
        it { expect(order.vendor_ship_total(vendor)).to eq(25) }
      end

      describe '#display_vendor_ship_total' do
        it { expect(order.display_vendor_ship_total(vendor).to_s).to eq('$25.00') }
      end

      describe '#vendor_pre_tax_ship_amount' do
        it { expect(order.vendor_pre_tax_ship_amount(vendor)).to eq(20) }
      end

      describe '#display_vendor_pre_tax_ship_amount' do
        it { expect(order.display_vendor_pre_tax_ship_amount(vendor).to_s).to eq('$20.00') }
      end
    end

    describe '#vendor_promo_total' do
      it { expect(order.vendor_promo_total(vendor)).to eq(-30) }
    end

    describe '#display_vendor_promo_total' do
      it { expect(order.display_vendor_promo_total(vendor).to_s).to eq('-$30.00') }
    end

    context 'additional tax' do
      before do
        order.vendor_line_items(vendor).update_all(additional_tax_total: 10)
        order.vendor_shipments(vendor).update_all(additional_tax_total: 1)
      end

      describe '#vendor_additional_tax_total' do
        it { expect(order.vendor_additional_tax_total(vendor)).to eq(31) }
      end

      describe '#display_vendor_additional_tax_total' do
        it { expect(order.display_vendor_additional_tax_total(vendor).to_s).to eq('$31.00') }
      end
    end

    context 'included tax' do
      before do
        order.vendor_line_items(vendor).update_all(included_tax_total: 5)
        order.vendor_shipments(vendor).update_all(included_tax_total: 1)
      end

      describe '#vendor_included_tax_total' do
        it { expect(order.vendor_included_tax_total(vendor)).to eq(16) }
      end

      describe '#display_vendor_included_tax_total' do
        it { expect(order.display_vendor_included_tax_total(vendor).to_s).to eq('$16.00') }
      end
    end

    describe '#vendor_total' do
      it { expect(order.vendor_total(vendor)).to eq(290) }
    end

    describe '#display_vendor_total' do
      it { expect(order.display_vendor_total(vendor).to_s).to eq('$290.00') }

      context 'respects currency' do
        before { order.currency = 'GBP' }

        it { expect(order.display_vendor_total(vendor).to_s).to eq('£290.00') }
      end
    end

    describe '#vendor_item_count' do
      before { order.vendor_line_items(vendor).last.update(quantity: 2) }

      it { expect(order.vendor_item_count(vendor)).to eq(4) }
    end

    describe '#vendor_ids' do
      it { expect(order.vendor_ids).to match_array([vendor.id, vendor_2.id]) }

      context 'when a line item does not belong to any vendor' do
        before { order.vendor_line_items(vendor_2).each { |li| li.product.update_columns(vendor_id: nil) } }
        it { expect(order.vendor_ids).to match_array([vendor.id]) }
      end
    end

    describe '#vendor_totals' do
      it { expect(order.vendor_totals).to be_kind_of(Array) }
      it { expect(order.vendor_totals).not_to be_empty }
      it { expect(order.vendor_totals.first.order).to eq(order) }
      it { expect(order.vendor_totals.map(&:vendor)).to match_array([vendor, vendor_2]) }
    end
  end
end
