require 'spec_helper'

describe Spree::V2::Storefront::VendorImageSerializer do
  let!(:vendor_image) { create(:vendor_image) }
  let!(:vendor) { create(:active_vendor, name: 'vendor', image: vendor_image) }

  subject { described_class.new(vendor_image) }

  it { expect(subject.serializable_hash).to be_kind_of(Hash) }

  it 'returns right data attributes' do
    expect(subject.serializable_hash[:data].keys).to contain_exactly(:id, :type, :attributes)
  end

  it 'returns right vendor_image attributes' do
    expect(subject.serializable_hash[:data][:attributes].keys).to contain_exactly(:styles)
  end
end
