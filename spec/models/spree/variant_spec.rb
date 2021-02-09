require 'spec_helper'

describe Spree::Variant do
  let(:vendor) { create :vendor }
  let(:other_vendor) { create :vendor, name: 'Other vendor' }
  let(:product) { create(:product, vendor: vendor) }
  subject { build(:variant, product: product) }

  context 'after create' do
    it "propagate to stock items only for Vendor's Stock Locations" do
      expect { create(:variant, product: product) }.to change {
        Spree::StockItem.where(stock_location: vendor.stock_locations.first).count
      }
    end

    it "doesn't propagate to stock items for other vendors Stock Locations" do
      expect { create(:variant, product: product) }.to_not change {
        Spree::StockItem.where(stock_location: other_vendor.stock_locations.first).count
      }
    end
  end

  describe '#assign_vendor' do
    context 'product vendorized, variant vendorized' do
      it 'copies from product' do
        expect(subject.attributes['vendor_id']).to be_nil
        subject.save!
        expect(subject.reload.attributes['vendor_id']).to eq(product.vendor_id)
      end
    end

    context 'product not vendorized, variant vendorized' do
      before do
        SpreeMultiVendor::Config[:vendorized_models] = ['variant']
      end

      after do
        SpreeMultiVendor::Config[:vendorized_models] = SpreeMultiVendor::Configuration::DEFAULT_VENDORIZED_MODELS
      end

      context 'no vendor' do
        let(:product) { create(:product) }

        it { expect { subject.save! }.not_to change { subject.vendor }.from(nil) }
      end

      context 'vendor assigned' do
        subject { build(:variant, product: product, vendor: vendor) }

        it { expect { subject.save! }.not_to change { subject.vendor }.from(vendor) }
      end
    end

    context 'product vendorized, variant not vendorized' do
      before do
        SpreeMultiVendor::Config[:vendorized_models] = ['product']
      end

      after do
        SpreeMultiVendor::Config[:vendorized_models] = SpreeMultiVendor::Configuration::DEFAULT_VENDORIZED_MODELS
      end

      it { expect { subject.save! }.not_to raise_error }
    end
  end

  describe '#vendor' do
    context 'product vendorized, variant vendorized' do
      before { subject.save! }

      it { expect(subject.vendor).to eq(product.vendor) }
    end

    context 'product not vendorized, variant vendorized' do
      before do
        SpreeMultiVendor::Config[:vendorized_models] = ['variant']
      end

      after do
        SpreeMultiVendor::Config[:vendorized_models] = SpreeMultiVendor::Configuration::DEFAULT_VENDORIZED_MODELS
      end

      let(:product) { create(:product) }
      subject { build(:variant, product: product, vendor: vendor) }

      it { expect(subject.vendor).to eq(vendor) }
    end

    context 'product vendorized, variant not vendorized' do
      before do
        SpreeMultiVendor::Config[:vendorized_models] = ['product']
        subject.save!
      end

      after do
        SpreeMultiVendor::Config[:vendorized_models] = SpreeMultiVendor::Configuration::DEFAULT_VENDORIZED_MODELS
      end

      it { expect(subject.vendor).to eq(product.vendor) }
    end
  end

  it { expect(described_class.whitelisted_ransackable_associations).to include('vendor') }
end
