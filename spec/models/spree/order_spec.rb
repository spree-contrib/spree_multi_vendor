require 'spec_helper'

describe Spree::Order do
  describe 'associations' do
    it { is_expected.to have_many(:commissions) }
  end
  describe 'finalize! with spree_multi_vendor' do
    it 'generates commission records' do
      order = create(:completed_order_with_totals, line_items: 6.times.map { create(:line_item) } )
      vendor1 = create(:vendor, name: "Vendor_1")
      vendor2 = create(:vendor, name: "Vendor_2")

      order.line_items.each_with_index do |li, idx|
        product = li.variant.product
        product.vendor = idx.odd? ? vendor1 : vendor2
        product.save
      end

      expect {
        order.finalize!
        order.reload
      }.to change { Spree::Order::Commission.count }.by(2)
      .and change { vendor1.commissions.count }.by(1)
      .and change { vendor2.commissions.count }.by(1)

      order.line_items.includes(product: :vendor).group_by{|li| li.product.vendor}.each do |vendor, line_items|
        expect(vendor.commissions.sum(:amount))
            .to eq (vendor.commission_rate * line_items.pluck(:pre_tax_amount).sum.to_f / 100)
      end
    end
  end
end
