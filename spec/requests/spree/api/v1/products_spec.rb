require 'spec_helper'

module Spree
  describe 'API V1 Products Spec', type: :request do
    let(:vendor) { create(:vendor, state: :active) }
    let(:other_vendor) { create(:vendor) }
    let(:shipping_category) { create(:shipping_category) }
    let(:selected_product) { product_without_vendor }
    let(:params) { {} }

    let!(:product_without_vendor) { create(:product) }
    let!(:product_with_vendor_vendor) { create(:product, vendor: vendor) }
    let!(:product_with_other_vendor) { create(:product, vendor: other_vendor) }

    before { stub_authentication! }

    describe 'products#index' do
      before { get '/api/v1/products', params: params }

      context 'as a regular user' do
        it 'gets a list of all products' do
          expect(response.status).to eq(200)
          expect(json_response[:products].size).to eq(3)
        end
      end

      context 'as an admin' do
        sign_in_as_admin!

        it 'gets a list of all products' do
          expect(response.status).to eq(200)
          expect(json_response[:products].size).to eq(3)
        end
      end

      context 'as a vendor' do
        let!(:current_api_user) do
          user = create(:user, vendors: [vendor])
          user
        end

        it 'gets a list of products assigned to that vendor' do
          expect(response.status).to eq(200)
          expect(json_response[:products].size).to eq(1)
          expect(json_response[:products][0][:id]).to eq(vendor.products.first.id)
        end
      end
    end

    describe 'products#show' do
      before { get "/api/v1/products/#{selected_product.id}" }

      it 'gets a product' do
        expect(response.status).to eq(200)
      end

      context 'as a vendor' do
        let!(:current_api_user) do
          user = create(:user, vendors: [vendor])
          user
        end

        describe 'cannot view product of another vendor' do
          let(:selected_product) { product_with_other_vendor }

          it do
            expect(response.status).to eq(404)
          end
        end

        describe 'can view product assigned to that vendor' do
          let(:selected_product) { product_with_vendor_vendor }

          it do
            expect(response.status).to eq(200)
          end
        end
      end
    end

    describe 'products#create' do
      let(:params) do
        {
          product: {
            name: 'Product',
            shipping_category_id: shipping_category.id,
            price: 12.34
          }
        }
      end

      before { post '/api/v1/products', params: params }

      context 'as regular user' do
        it 'cannot create a new product' do
          expect(response.status).to eq(401)
        end
      end

      context 'as an admin' do
        sign_in_as_admin!

        it 'can create a new product' do
          expect(response.status).to eq(201)
          expect(json_response['name']).to eq(params[:product][:name])
          expect(json_response['price']).to eq(params[:product][:price].to_s)
          expect(json_response['shipping_category_id']).to eq(params[:product][:shipping_category_id])
        end
      end

      context 'as a vendor' do
        let!(:current_api_user) do
          user = create(:user, vendors: [vendor])
          user
        end

        it 'can create a new product assigned to vendor' do
          expect(response.status).to eq(201)
          product = Spree::Product.find(json_response[:id])
          expect(product.vendor).to eq(vendor)
        end
      end
    end

    describe 'products#update' do
      let(:params) do
        {
          product: {
            name: 'Updated Prodouct',
            shipping_category_id: shipping_category.id,
            price: 12.34
          }
        }
      end

      before { put "/api/v1/products/#{selected_product.id}", params: params }

      context 'as regular user' do
        it 'cannot update product' do
          expect(response.status).to eq(401)
        end
      end

      context 'as an admin' do
        sign_in_as_admin!

        it 'can update product' do
          expect(response.status).to eq(200)
          expect(json_response['name']).to eq(params[:product][:name])
          expect(json_response['price']).to eq(params[:product][:price].to_s)
          expect(json_response['shipping_category_id']).to eq(params[:product][:shipping_category_id])
        end
      end

      context 'as a vendor' do
        let!(:current_api_user) do
          user = create(:user, vendors: [vendor])
          user
        end

        describe 'cannot update product of another vendor' do
          let(:selected_product) { product_with_other_vendor }

          it do
            expect(response.status).to eq(404)
          end
        end

        describe 'can update product assigned to that vendor' do
          let(:selected_product) { product_with_vendor_vendor }

          it do
            expect(response.status).to eq(200)
          end
        end
      end
    end

    describe 'products#destroy' do
      before { delete "/api/v1/products/#{selected_product.id}" }

      context 'as regular user' do
        it 'cannot delete product' do
          expect(response.status).to eq(401)
        end
      end

      context 'as an admin' do
        sign_in_as_admin!

        it 'can delete product' do
          expect(response.status).to eq(204)
          expect(product_without_vendor.reload.deleted_at).to_not eq(nil)
        end
      end

      context 'as a vendor' do
        let!(:current_api_user) do
          user = create(:user, vendors: [vendor])
          user
        end

        describe 'cannot delete product of another vendor' do
          let(:selected_product) { product_with_other_vendor }

          it do
            expect(response.status).to eq(404)
          end
        end

        describe 'can delete product assigned to that vendor' do
          let(:selected_product) { product_with_vendor_vendor }

          it do
            expect(response.status).to eq(204)
          end
        end
      end
    end
  end
end
