require 'timecop'

describe Spree::Product do
  let(:vendor) { create(:vendor) }
  let(:product) { create(:product, vendor: vendor) }

  context '.whitelisted_ransackable_associations' do
    it { expect(described_class.whitelisted_ransackable_associations).to include('vendor') }
    it { expect(described_class.whitelisted_ransackable_associations.count).to be > 1 }
  end

  it 'touches vendor after update' do
    time = Time.current + 1.hour
    product
    Timecop.freeze(time) do
      expect { product.touch }.to change { vendor.reload.updated_at }
    end
  end
end
