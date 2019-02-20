module Spree
  class VendorsController < Spree::StoreController
    before_action :load_vendor, only: :show

    def show; end

    private

    def load_vendor
      @vendor = Vendor.friendly.find(params[:id])
    end
  end
end
