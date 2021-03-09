require 'spec_helper'

module Spree
  describe 'API V1 Vendors Spec', type: :request do
    let(:params) { {} }
    let(:selected_vendor) { vendor }

    let!(:vendor) { create(:vendor, state: :active) }
    let!(:another_vendor) { create(:vendor, state: :active) }

    before { stub_authentication! }

    describe 'vendors#index' do
      before { get '/api/v1/vendors', params: params }

      context 'as a regular user' do
        it 'gets an empty list' do
          expect(response.status).to eq(200)
          expect(json_response.size).to eq(0)
        end
      end

      context 'as an admin' do
        sign_in_as_admin!

        it 'gets a list of all vendors' do
          expect(response.status).to eq(200)
          expect(json_response.size).to eq(2)
        end
      end

      context 'as a vendor' do
        let!(:current_api_user) do
          user = create(:user, vendors: [vendor])
          user
        end

        it 'gets a list of assigned vendors' do
          expect(response.status).to eq(200)
          expect(json_response.size).to eq(1)
          expect(json_response[0]['id']).to eq(vendor.id)
        end
      end
    end

    describe 'vendors#show' do
      before { get "/api/v1/vendors/#{selected_vendor.id}" }

      context 'as a regular user' do
        it 'cannot view a vendor' do
          expect(response.status).to eq(404)
        end
      end

      context 'as an admin' do
        sign_in_as_admin!
        it 'can view a vendor' do
          expect(response.status).to eq(200)
        end
      end

      context 'as a vendor' do
        let!(:current_api_user) do
          user = create(:user, vendors: [vendor])
          user
        end

        describe 'can view a assigned vendor' do
          it do
            expect(response.status).to eq(200)
          end
        end

        describe 'cannot view an another vendor' do
          let(:selected_vendor) { another_vendor }

          it do
            expect(response.status).to eq(404)
          end
        end
      end
    end

    describe 'vendors#create' do
      let(:params) do
        {
          vendor: {
            name: 'name'
          }
        }
      end

      before { post '/api/v1/vendors', params: params }

      context 'as regular user' do
        it 'cannot create a new vendor' do
          expect(response.status).to eq(401)
        end
      end

      context 'as an admin' do
        sign_in_as_admin!

        it 'can create a new vendor' do
          expect(response.status).to eq(201)
          expect(json_response['name']).to eq(params[:vendor][:name])
        end
      end

      context 'as a vendor' do
        let!(:current_api_user) do
          user = create(:user, vendors: [vendor], email: FFaker::Internet.email)
          user
        end

        it 'cannot create a new vendor' do
          expect(response.status).to eq(401)
        end
      end
    end

    describe 'vendors#update' do
      let(:params) do
        {
          vendor: {
            name: 'updated name'
          }
        }
      end

      before { put "/api/v1/vendors/#{selected_vendor.id}", params: params }

      context 'as regular user' do
        it 'cannot update vendor' do
          expect(response.status).to eq(404)
        end
      end

      context 'as an admin' do
        sign_in_as_admin!

        it 'can update vendor' do
          expect(response.status).to eq(200)
          expect(json_response['name']).to eq(params[:vendor][:name])
        end
      end

      context 'as a vendor' do
        let!(:current_api_user) do
          user = create(:user, vendors: [vendor])
          user
        end

        describe 'can update as assigned vendor' do
          it do
            expect(response.status).to eq(200)
          end
        end

        describe 'cannot update an another vendor' do
          let(:selected_vendor) { another_vendor }

          it do
            expect(response.status).to eq(404)
          end
        end
      end
    end

    describe 'vendors#destroy' do
      before { delete "/api/v1/vendors/#{selected_vendor.id}" }

      context 'as regular user' do
        it 'cannot delete vendor' do
          expect(response.status).to eq(404)
        end
      end

      context 'as an admin' do
        sign_in_as_admin!

        it 'can delete vendor' do
          expect(response.status).to eq(204)
          expect(vendor.reload.deleted_at).to_not eq(nil)
        end
      end

      context 'as a vendor' do
        let!(:current_api_user) do
          user = create(:user, vendors: [vendor])
          user
        end

        describe 'can delete an assigned vendor' do
          it do
            expect(response.status).to eq(204)
          end
        end

        describe 'cannot delete an another vendor' do
          let(:selected_vendor) { another_vendor }

          it do
            expect(response.status).to eq(404)
          end
        end
      end
    end
  end
end
