module Spree
  class VendorsController < Spree::StoreController
    before_action :load_taxon, only: :show

    def index
      @vendors = Spree::Vendor.active
    end

    def show
      @vendor = Spree::Vendor.active.friendly.find(params[:id])
      @searcher = build_searcher(searcher_params)
      # TODO: we should modify searcher instead of this, adding vendor to searcher params is not enough
      @products = @searcher.retrieve_products.where(vendor_id: @vendor.id)
    end

    def new
      @vendor = Spree::Vendor.new
      @stock_location = Spree::StockLocation.new(country_id: Spree::Config[:default_country_id])
    end

    def create
      @vendor = Spree::Vendor.new(vendor_params.except(:image, :user))
      @vendor.build_image(attachment: vendor_params[:image]) if vendor_params[:image]
      @user = params[:spree_vendor][:user] ? Spree::User.new(vendor_user_params) : spree_current_user
      @stock_location = Spree::StockLocation.new(vendor_stock_location_params)

      if @user.valid? && @stock_location.valid? && @vendor.save
        @user.vendors << @vendor
        @user.save
        @stock_location.vendor = @vendor
        @stock_location.save
        Spree::VendorSignupMailer.notify_admins(@vendor, @user).deliver_later
        flash[:success] = I18n.t('devise.registrations.signed_up_but_inactive')
        redirect_to root_path
      else
        @vendor.valid?
        redirect_back fallback_location: root_path
      end
    end

    private

    def load_taxon
      @taxon ||= Spree::Taxon.friendly.find(params[:taxon_id]) if params[:taxon_id].present?
    end

    def searcher_params
      searcher_params = params.merge(include_images: true)
      searcher_params[:taxon] = load_taxon.id if load_taxon.present?
      searcher_params
    end

    def vendor_params
      params.require(:spree_vendor).permit(
        *Spree::PermittedAttributes.vendor_attributes,
        stock_locations_attributes: Spree::PermittedAttributes.stock_location_attributes
      )
    end

    def vendor_user_params
      params.require(:spree_vendor).require(:user).permit(Spree::PermittedAttributes.user_attributes)
    end

    def vendor_stock_location_params
      params.require(:spree_vendor).require(:stock_location).permit(Spree::PermittedAttributes.stock_location_attributes)
    end
  end
end
