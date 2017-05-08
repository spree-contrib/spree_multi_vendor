require 'spec_helper'

describe Spree::OrderSplitter do
  let(:vendor) { create(:vendor) }
  let(:product) do
    product = create(:product_in_stock, vendor_id: vendor.id)
    product.master.update(vendor_id: vendor.id)
    product
  end
  let!(:order) { create(:order) }
  let!(:line_item) { create(:line_item, variant: product.master, order: order) }

  subject { described_class.new(order) }

  context "#split!" do
    it 'should create a new order' do
      expect { subject.split! }.to change(Spree::Order, :count).by 1
    end
  end
end
