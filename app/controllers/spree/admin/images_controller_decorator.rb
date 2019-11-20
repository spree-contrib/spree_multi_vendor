module Spree
  module Admin
    class ImagesController < ResourceController
      before_action :load_edit_data, except: :index
      before_action :load_index_data, only: :index

      create.before :set_viewable
      update.before :set_viewable

      def edit
        if params[:vendor_id].present?
          @vendor  = Spree::Vendor.friendly.find(params[:vendor_id])
          render 'edit_vendor'
        else
          respond_with(@object) do |format|
            format.html { render layout: !request.xhr? }
            format.js   { render layout: false } if request.xhr?
          end
        end
      end

      def update
        invoke_callbacks(:update, :before)
        if @object.update(permitted_resource_params)
          invoke_callbacks(:update, :after)
          if params[:vendor_id].present?
            @vendor  = Spree::Vendor.friendly.find(params[:vendor_id])
            redirect_vendor_image
          else
            respond_with(@object) do |format|
              format.html do
                flash[:success] = flash_message_for(@object, :successfully_updated)
                redirect_to location_after_save
              end
              format.js { render layout: false }
            end
          end

        else
          invoke_callbacks(:update, :fails)
          if params[:vendor_id].present?
            @vendor  = Spree::Vendor.friendly.find(params[:vendor_id])
            redirect_vendor_image
          else
            respond_with(@object) do |format|
              format.html { render action: :edit }
              format.js { render layout: false }
            end
          end

        end
      end

      def destroy
        invoke_callbacks(:destroy, :before)
        if @object.destroy
          if params[:vendor_id].present?
            @vendor  = Spree::Vendor.friendly.find(params[:vendor_id])
            # redirect_vendor_image
            respond_with(@vendor) do |format|
              format.html {render :js => "window.location.href='"+request.referer+"'" }
              format.js { render :js => "window.location.href='"+request.referer+"'" }
            end
            return
          else
            invoke_callbacks(:destroy, :after)
            flash[:success] = flash_message_for(@object, :successfully_removed)
          end

        else
          if params[:vendor_id].present?
            @vendor  = Spree::Vendor.friendly.find(params[:vendor_id])
            # redirect_vendor_image
            respond_with(@vendor) do |format|
              format.html {render :js => "window.location.href='"+request.referer+"'" }
              format.js { render :js => "window.location.href='"+request.referer+"'" }
            end
            return
          else
            invoke_callbacks(:destroy, :fails)
            flash[:error] = @object.errors.full_messages.join(', ')
          end

        end

      end

      def create

        invoke_callbacks(:create, :before)
        @object.attributes = permitted_resource_params
        if @object.save
          if params[:vendor_id].present?
            @vendor  = Spree::Vendor.friendly.find(params[:vendor_id])
            redirect_vendor_image
          else
            invoke_callbacks(:create, :after)
            flash[:success] = flash_message_for(@object, :successfully_created)
            respond_with(@object) do |format|
              format.html { redirect_to location_after_save }
              format.js   { render layout: false }
            end
          end

        else
          if params[:vendor_id].present?
            redirect_vendor_image
          end
          invoke_callbacks(:create, :fails)
          respond_with(@object) do |format|
            format.html { render action: :new }
            format.js { render layout: false }
          end
        end
      end

      def redirect_vendor_image
          render "vendor_index"
      end

      private

      def location_after_destroy
        admin_product_images_url(@product)
      end

      def location_after_save
        admin_product_images_url(@product)
      end

      def load_index_data
        if params[:vendor_id].present?
          @vendor = Vendor.friendly.find(params[:vendor_id])
          render "vendor_index"
        else
          @product = Product.friendly.includes(*variant_index_includes).find(params[:product_id])
        end
      end

      def load_edit_data
        if params[:vendor_id].present?
          load_edit_data_vendors
          if params[:action] == "new"
            render "spree/admin/images/new_vendor"
          end
        else
          load_edit_data_products
        end
      end

      def load_edit_data_products
        @product = Product.friendly.includes(*variant_edit_includes).find(params[:product_id])
        @variants = @product.variants.map do |variant|
          [variant.sku_and_options_text, variant.id]
        end
        @variants.insert(0, [Spree.t(:all), @product.master.id])
      end

      def load_edit_data_vendors
        @vendors = Vendor.friendly.find(params[:vendor_id])
        @taxons = Spree::Taxonomy.includes(root: :children).find_by(name: 'Image_Category').taxons.select{|s|s.children.empty?}

      end

      def set_viewable
        if params[:vendor_id].present?
          @image.viewable_type = 'Spree::Vendor'
          @image.viewable_id = Spree::Vendor.friendly.find(params[:vendor_id]).id
          @taxons = Spree::Taxonomy.includes(root: :children).find_by(name: 'Image_Category').taxons.select{|s|s.children.empty?}
          # render "new_vendor"
        else
          @image.viewable_type = 'Spree::Variant'
          @image.viewable_id = params[:image][:viewable_id]
        end

      end

      def variant_index_includes
        [
            variant_images: [viewable: { option_values: :option_type }]
        ]
      end

      def variant_edit_includes
        [
            variants_including_master: { option_values: :option_type, images: :viewable }
        ]
      end
      def permitted_resource_params
        params[resource.object_name].present? ? params.require(resource.object_name).permit! : ActionController::Parameters.new
      end
    end
  end
end
