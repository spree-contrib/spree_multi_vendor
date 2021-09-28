module Spree
  module Admin
    class VendorsController < ResourceController

      def create
        if permitted_resource_params[:image]
          @vendor.build_image(attachment: permitted_resource_params.delete(:image))
        end

        if permitted_resource_params[:banner]
          @vendor.build_banner(attachment: permitted_resource_params.delete(:banner))
        end
        super
      end

      def update
        if permitted_resource_params[:image]
          @vendor.create_image(attachment: permitted_resource_params.delete(:image))
        end

        if permitted_resource_params[:banner]
          @vendor.create_banner(attachment: permitted_resource_params.delete(:banner))
        end

        format_translations if defined? SpreeGlobalize
        super
      end

      def update_positions
        params[:positions].each do |id, position|
          vendor = Spree::Vendor.find(id)
          vendor.set_list_position(position)
        end

        respond_to do |format|
          format.js { render plain: 'Ok' }
        end
      end

      private

      def find_resource
        Vendor.with_deleted.friendly.find(params[:id])
      end

      def collection
        params[:q] = {} if params[:q].blank?
        vendors = super.order(priority: :asc)
        @search = vendors.ransack(params[:q])

        @collection = @search.result.
            includes(vendor_includes).
            page(params[:page]).
            per(params[:per_page])
      end

      def vendor_includes
        {
          image: [],
          products: [],
          banner: []
        }

      end

      def format_translations
        return if params[:vendor][:translations_attributes].blank?
        params[:vendor][:translations_attributes].each do |_, data|
          translation = @vendor.translations.find_or_create_by(locale: data[:locale])
          translation.name = data[:name]
          translation.about_us = data[:about_us]
          translation.contact_us = data[:contact_us]
          translation.slug = data[:slug]
          translation.save!
        end
      end
    end
  end
end
