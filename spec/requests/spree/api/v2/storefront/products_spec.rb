require 'spec_helper'

describe 'API V2 Storefront Products Spec', type: :request do
  let!(:products)              { create_list(:product, 5) }
  let!(:vendor)                { create(:vendor) }
  let!(:vendor_2)              { create(:vendor) }

  before do
    vendors = Spree::Vendor.all.to_a
    products.each do |product|
      product.vendor = vendors.sample
      product.save!
    end
  end

  describe 'products#index' do
    context 'with no params' do
      before { get '/api/v2/storefront/products' }

      it_behaves_like 'returns 200 HTTP status'

      it 'returns all products' do
        expect(json_response['data'].count).to eq Spree::Product.available.count
        expect(json_response['data'].first).to have_type('product')
      end
    end

    context 'with specified vendor ids' do
      before { get "/api/v2/storefront/products?filter[vendor_ids]=#{vendor.id}&include=vendor" }

      it_behaves_like 'returns 200 HTTP status'

      it 'returns products with specified ids' do
        expect(json_response['data'].count).to eq Spree::Product.available.where(vendor_id: vendor.id).count
        expect(json_response['included'].first).to have_id(vendor.id.to_s)
        expect(json_response['included'].first).to have_attribute(:name).with_value(vendor.name)
        expect(json_response['included'].first).to have_attribute(:about_us).with_value(vendor.about_us)
      end
    end

    context 'with specified multiple filters' do
      before { get "/api/v2/storefront/products?filter[skus]=#{products.first.sku}&filter[vendor_ids]=#{products.first.vendor_id}&include=vendor" }

      it_behaves_like 'returns 200 HTTP status'

      it 'returns products with specified SKU and Vendor ID' do
        expect(json_response['data'].count).to eq 1
        expect(json_response['data'].first).to have_id(products.first.id.to_s)
        expect(json_response['included'].first).to have_id(products.first.vendor_id.to_s)
        expect(json_response['included'].first).to have_attribute(:name).with_value(products.first.vendor.name)
        expect(json_response['included'].first).to have_attribute(:about_us).with_value(products.first.vendor.about_us)
      end
    end
  end
end
