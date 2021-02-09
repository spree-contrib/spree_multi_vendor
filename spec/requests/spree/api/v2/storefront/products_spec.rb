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

  describe 'products#show' do
    let(:product) { products.first }

    context 'with existing product' do
      before { get "/api/v2/storefront/products/#{product.slug}?include=vendor" }

      it_behaves_like 'returns 200 HTTP status'

      it 'returns a valid JSON response' do
        expect(json_response['data']).to have_id(product.id.to_s)

        expect(json_response['data']).to have_type('product')

        expect(json_response['data']).to have_attribute(:name).with_value(product.name)
        expect(json_response['data']).to have_attribute(:description).with_value(product.description)
        expect(json_response['data']).to have_attribute(:price).with_value(product.price.to_s)
        expect(json_response['data']).to have_attribute(:currency).with_value(product.currency)
        expect(json_response['data']).to have_attribute(:display_price).with_value(product.display_price.to_s)
        expect(json_response['data']).to have_attribute(:available_on).with_value(product.available_on.as_json)
        expect(json_response['data']).to have_attribute(:slug).with_value(product.slug)
        expect(json_response['data']).to have_attribute(:meta_description).with_value(product.meta_description)
        expect(json_response['data']).to have_attribute(:meta_keywords).with_value(product.meta_keywords)
        expect(json_response['data']).to have_attribute(:updated_at).with_value(product.updated_at.as_json)
        expect(json_response['data']).to have_attribute(:purchasable).with_value(product.purchasable?)
        expect(json_response['data']).to have_attribute(:in_stock).with_value(product.in_stock?)
        expect(json_response['data']).to have_attribute(:backorderable).with_value(product.backorderable?)

        expect(json_response['data']).to have_relationships(
          :variants, :option_types, :product_properties, :default_variant, :vendor
        )

        expect(json_response['included'].first).to have_id(product.vendor_id.to_s)
        expect(json_response['included'].first).to have_attribute(:name).with_value(product.vendor.name)
        expect(json_response['included'].first).to have_attribute(:about_us).with_value(product.vendor.about_us)
      end
    end
  end
end
