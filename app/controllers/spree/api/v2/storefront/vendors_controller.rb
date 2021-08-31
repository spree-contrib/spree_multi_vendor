module Spree
  module Api
    module V2
      module Storefront
        class VendorsController < ::Spree::Api::V2::ResourceController
          include Spree::Api::V2::BaseController
          include Spree::Api::V2::CollectionOptionsHelpers

          def index
            render_serialized_payload { {"hello":"world"} }
          end

          
          private

          def model_class
            ::Spree::Vendor
          end

          def scope
            ::Spree::Vendor.active
          end

          def resource
            scope.find_by(slug: params[:id]) || scope.find(params[:id])
          end

          def resource_serializer
            Spree::V2::Storefront::VendorSerializer
          end
        end
      end
    end
  end
end
