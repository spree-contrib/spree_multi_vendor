require 'spec_helper'

describe 'API V2 Storefront Cart Spec', type: :request do
  let(:default_currency) { 'USD' }
  let(:store) { Spree::Store.default }
  let(:currency) { store.default_currency }
  let(:user)  { create(:user) }
  let(:order) { create(:order, user: user, store: store, currency: currency) }
  let!(:vendor) { create(:vendor) }
  let!(:vendor_2) { create(:vendor) }
  let(:product) { create(:product_in_stock, vendor: vendor) }
  let(:product_2) { create(:product_in_stock, vendor: vendor_2) }

  include_context 'API v2 tokens'

  describe 'cart#show' do
    let(:params) { {} }
    let!(:line_item) { create(:line_item, order: order, product: product, variant: product.default_variant) }

    shared_examples 'showing the cart' do
      before do
        get '/api/v2/storefront/cart', headers: headers_bearer, params: params
      end

      it_behaves_like 'returns 200 HTTP status'
      it_behaves_like 'returns valid cart JSON'
    end

    context 'with one vendor' do
      let(:params) { { include: 'vendors,vendor_totals' } }

      it_behaves_like 'showing the cart'

      it 'includes vendor and vendor totals' do
        get '/api/v2/storefront/cart', headers: headers_bearer, params: params

        expect(json_response['data']).to have_relationships(:vendors, :vendor_totals)
        expect(json_response[:included][0]).to have_id(vendor.id.to_s)
        expect(json_response[:included][0]).to have_type('vendor')
        expect(json_response[:included][1]).to have_id(vendor.id.to_s)
        expect(json_response[:included][1]).to have_type('vendor_totals')
      end
    end

    context 'with many vendors' do
      let!(:line_item_2) { create(:line_item, order: order, product: product_2, variant: product_2.default_variant) }
      let(:params) { { include: 'vendors,vendor_totals' } }

      it_behaves_like 'showing the cart'

      it 'includes many vendors and vendor totals' do
        get '/api/v2/storefront/cart', headers: headers_bearer, params: params

        [vendor, vendor_2].each do |vendor|
          expect(json_response['included']).to include(have_type('vendor').and have_id(vendor.id.to_s))
          expect(json_response['included']).to include(have_type('vendor_totals').and have_id(vendor.id.to_s))
          expect(json_response['included']).to include(have_type('vendor').and have_attribute(:name).with_value(vendor.name))
          expect(json_response['included']).to include(have_type('vendor_totals').and have_attribute(:name).with_value(vendor.name))
        end
      end
    end

    context 'includes line item vendor data' do
      it_behaves_like 'showing the cart'

      it 'via variants' do
        get '/api/v2/storefront/cart', params: { include: 'variants.vendor' }, headers: headers_bearer
        expect(json_response[:included][0]).to have_id(vendor.id.to_s)
        expect(json_response[:included][0]).to have_type('vendor')
      end

      it 'via products' do
        get '/api/v2/storefront/cart', params: { include: 'variants.product.vendor' }, headers: headers_bearer
        expect(json_response[:included][0]).to have_id(vendor.id.to_s)
        expect(json_response[:included][0]).to have_type('vendor')
      end

      it 'via line_items' do
        get '/api/v2/storefront/cart', params: { include: 'line_items.vendor' }, headers: headers_bearer
        expect(json_response[:included][0]).to have_id(vendor.id.to_s)
        expect(json_response[:included][0]).to have_type('vendor')
      end
    end
  end
end
