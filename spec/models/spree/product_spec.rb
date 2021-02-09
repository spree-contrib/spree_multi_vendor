describe Spree::Product do
  let(:vendor) { create(:vendor) }
  let(:product) { create(:product, vendor: vendor) }

  context '.whitelisted_ransackable_associations' do
    it { expect(described_class.whitelisted_ransackable_associations).to include('vendor') }
    it { expect(described_class.whitelisted_ransackable_associations.count).to be > 1 }
  end

  it { expect { product.touch }.to change { vendor.updated_at } }
end
