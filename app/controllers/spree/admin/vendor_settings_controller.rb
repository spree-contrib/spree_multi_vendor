module Spree
  module Admin
    class VendorSettingsController < Spree::Admin::BaseController
      before_action :authorize
      before_action :load_vendor

      def update
        if vendor_params[:image]
          @vendor.create_image(attachment: vendor_params[:image])
        end

        if vendor_params[:banenr]
          @vendor.create_banner(attachment: vendor_params[:banner])
        end

        if @vendor.update(vendor_params.except(:image)) || @vendor.update(vendor_params.except(:banner)) 
          redirect_to admin_vendor_settings_path
        else
          render :edit
        end
      end

      private

      def authorize
        authorize! :manage, :vendor_settings
      end

      def load_vendor
        @vendor = current_spree_vendor
        raise ActiveRecord::RecordNotFound unless @vendor
      end

      def vendor_params
        params.require(:vendor).permit(Spree::PermittedAttributes.vendor_attributes)
      end
    end
  end
end
