require 'spec_helper'

describe Spree::Variant do
  let(:vendor) { create :vendor }
  let(:other_vendor) { create :vendor, name: 'Other vendor' }
  let(:product) { create(:product, vendor: vendor) }
  subject { create(:variant, product: product) }

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
end
