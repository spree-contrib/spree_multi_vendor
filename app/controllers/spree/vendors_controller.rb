module Spree
  class VendorsController < Spree::StoreController
    before_action :load_taxon, only: :show
    before_action :load_vendor, only: :show

    def show
      @searcher = build_searcher(searcher_params)
      @products = @searcher.retrieve_products
    end

    private

    def load_vendor
      @vendor = Vendor.friendly.find(params[:id])
    end

    def load_taxon
      @taxon = Spree::Taxon.friendly.find(params[:taxon_id]) if params[:taxon_id]
    end

    def searcher_params
      searcher_params = params.merge(vendor: @vendor.id, include_images: true)
      searcher_params[:taxon] = @taxon.id unless @taxon.blank?
      searcher_params
    end
  end
end
