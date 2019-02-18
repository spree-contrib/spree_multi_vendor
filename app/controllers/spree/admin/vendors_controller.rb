module Spree
  module Admin
    class VendorsController < ResourceController

      def create
        if permitted_resource_params[:image] && Spree.version.to_f >= 3.6
          @vendor.build_image(attachment: permitted_resource_params.delete(:image))
        end
        super
      end

      def update
        if permitted_resource_params[:image] && Spree.version.to_f >= 3.6
          @vendor.create_image(attachment: permitted_resource_params.delete(:image))
        end
        super
      end

      private

      def find_resource
        Vendor.with_deleted.friendly.find(params[:id])
      end

      def collection
        params[:q] = {} if params[:q].blank?
        vendors = super.order(name: :asc)
        @search = vendors.ransack(params[:q])

        @collection = @search.result.
                      page(params[:page]).
                      per(params[:per_page])
      end
    end
  end
end
