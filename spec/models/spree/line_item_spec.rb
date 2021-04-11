require 'spec_helper'

describe Spree::LineItem do
  let(:vendor) { create(:vendor) }

  describe '#vendor' do
    context 'vendorized product' do
      let(:product) { create(:product, vendor: vendor) }
      let(:line_item) { build(:line_item, product: product, variant: product.default_variant) }

      it { expect(line_item.vendor).not_to be_nil }
      it { expect(line_item.vendor).to eq(product.vendor) }
    end

    context 'vendorized variant' do
      let(:product) { create(:product) }
      let(:variant) { create(:variant, vendor: vendor, product: product) }
      let(:line_item) { build(:line_item, product: product, variant: variant) }

      before do
        SpreeMultiVendor::Config[:vendorized_models] = ['variant']
      end

      after do
        SpreeMultiVendor::Config[:vendorized_models] = SpreeMultiVendor::Configuration::DEFAULT_VENDORIZED_MODELS
      end

      it { expect(line_item.vendor).not_to be_nil }
      it { expect(line_item.vendor).to eq(variant.vendor) }
    end
  end
end
