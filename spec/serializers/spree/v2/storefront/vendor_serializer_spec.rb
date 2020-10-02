require 'spec_helper'

describe Spree::V2::Storefront::VendorSerializer do
  let(:vendor) { create(:vendor, name: 'Test', about_us: 'Hello World') }

  subject { described_class.new(vendor) }

  it { expect(subject.serializable_hash).to be_kind_of(Hash) }
  it do
    expect(subject.serializable_hash).to eq(
      {
        data: {
          id: vendor.id.to_s,
          type: :vendor,
          attributes: {
            name: 'Test',
            about_us: 'Hello World'
          }
        }
      }
    )
  end
end
