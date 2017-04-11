module Spree
  module Admin
    class VendorsController < ResourceController
      private

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
