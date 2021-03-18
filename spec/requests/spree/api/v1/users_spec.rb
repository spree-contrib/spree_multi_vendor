require 'spec_helper'

module Spree
  describe 'API V1 Users Spec', type: :request do
    let(:user) { create(:user) }
    let(:vendor) { create(:vendor, state: :active) }

    before { stub_authentication! }

    describe 'users#update' do
      let(:params) do
        {
          user: {
            vendor_ids: [vendor.id]
          }
        }
      end

      before { put "/api/v1/users/#{user.id}", params: params }

      context 'as an admin' do
        sign_in_as_admin!

        it 'can update user' do
          expect(response.status).to eq(200)
          expect(json_response['vendor_ids']).to eq([vendor.id])
        end
      end
    end
  end
end
