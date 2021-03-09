module Spree
  module Api
    module V1
      class VendorsController < Spree::Api::BaseController
        def index
          @vendors = if params[:ids].present?
                       scope.where(id: params[:ids].split(','))
                     else
                       scope.load.ransack(
                         params[:q]
                       ).result
                     end
          respond_with(@vendors)
        end

        def show
          @vendor = scope.find(params[:id])
          authorize! :show, @vendor
          respond_with(@vendor)
        end

        def create
          authorize! :create, Spree::Vendor
          @vendor = Spree::Vendor.new(vendor_params)
          if @vendor.save
            render :show, status: 201
          else
            invalid_resource!(@vendor)
          end
        end

        def update
          @vendor = scope.find(params[:id])
          authorize! :update, @vendor
          if @vendor.update(vendor_params)
            render :show
          else
            invalid_resource!(@vendor)
          end
        end

        def destroy
          @vendor = scope.find(params[:id])
          authorize! :destroy, @vendor
          @vendor.destroy
          render plain: nil, status: 204
        end

        private

        def scope
          Spree::Vendor.accessible_by(current_ability)
        end

        def vendor_params
          params.require(:vendor).permit(Spree::PermittedAttributes.vendor_attributes)
        end
      end
    end
  end
end
