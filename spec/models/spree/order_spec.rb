require 'spec_helper'

describe Spree::Order do
  describe 'associations' do
    it { is_expected.to have_many(:commissions) }
  end
  describe 'complete with spree_multi_vendor' do
    it 'generates commission records' do
      order = create(:order_with_line_items, state: 'payment', line_items: 6.times.map { create(:line_item) } )
      allow(order).to receive_messages payment_required?: false
      vendor1 = create(:vendor, name: "Vendor 1")
      vendor2 = create(:vendor, name: "Vendor 2")

      order.line_items[0..-2].each_with_index do |li, idx|
        product = li.variant.product
        product.vendor = idx.odd? ? vendor1 : vendor2
        product.save
      end

      expect {
        order.next!
        order.reload
      }.to change { Spree::OrderCommission.count }.by(2)
      .and change { vendor1.commissions.count }.by(1)
      .and change { vendor2.commissions.count }.by(1)

      order.line_items.includes(product: :vendor).group_by{|li| li.product.vendor}.each do |vendor, line_items|
        next unless vendor
        expect(vendor.commissions.sum(:amount))
            .to eq (vendor.commission_rate * line_items.pluck(:pre_tax_amount).sum.to_f / 100)
      end
    end
  end
end
