require 'spec_helper'

describe Spree::Vendor do
  describe 'associations' do
    it { is_expected.to have_many(:stock_locations) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'initial state' do
    it 'initial state should be pending' do
      should be_pending
    end
  end

  describe 'after_create' do
    let!(:vendor) { build(:vendor) }
    let!(:default_country) { create(:country) }

    before do
      Spree::Config[:default_country_id] = default_country.id
    end

    it 'creates a stock location with default country' do
      expect { vendor.save! }.to change(Spree::StockLocation, :count).by(1)
      stock_location = Spree::StockLocation.last
      expect(vendor.stock_locations.first).to eq stock_location
      expect(stock_location.country).to eq default_country
    end
  end
end
