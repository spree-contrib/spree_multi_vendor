require 'spec_helper'

describe 'API V2 Storefront Vendor Spec', type: :request do

  let!(:vendor_image) { create(:vendor_image) }
  let!(:vendor) { create(:active_vendor, name: 'vendor', image: vendor_image) }
  let!(:product) { create(:product, vendor: vendor) }

  describe 'vendors#show' do
    context 'with invalid slug param' do
      before { get '/api/v2/storefront/vendors/vendor1' }

      it_behaves_like 'returns 404 HTTP status'
    end

    context 'with valid slug param' do
      before { get "/api/v2/storefront/vendors/#{vendor.slug}" }

      it_behaves_like 'returns 200 HTTP status'

      it 'returns one vendor' do
        json_response = JSON.parse(response.body)
        expect(json_response.count).to eq 1
        expect(json_response['data']['type']).to eq('vendor')
      end

      it 'does not return included' do
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to contain_exactly('data')
      end
    end

    context 'with products and images included' do
      before { get "/api/v2/storefront/vendors/#{vendor.slug}?include=products,image" }

      it_behaves_like 'returns 200 HTTP status'

      it 'returns product information' do
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to contain_exactly('data', 'included')
        expect(json_response['included'].first['id']).to eq(product.id.to_s)
      end

      it 'returns image information' do
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to contain_exactly('data', 'included')

        expect(json_response['included'].second['id']).to eq(vendor_image.id.to_s)
      end
    end
  end
end
