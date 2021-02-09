describe Spree::Product do
  let(:vendor) { create(:vendor) }
  let(:product) { create(:product, vendor: vendor) }

  it { expect { product.touch }.to change { vendor.updated_at } }
end
