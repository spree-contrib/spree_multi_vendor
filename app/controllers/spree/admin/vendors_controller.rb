module Spree
  module Admin
    class VendorsController < ResourceController

      def create
        if permitted_resource_params[:image] && Spree.version.to_f >= 3.6
          @vendor.build_image(attachment: permitted_resource_params.delete(:image))
        end
        invoke_callbacks(:create, :before)
        @object.attributes = permitted_resource_params
        if @object.save
          invoke_callbacks(:create, :after)
          flash[:success] = flash_message_for(@object, :successfully_created)
          respond_with(@object) do |format|
            if spree_current_user.has_spree_role? :dropit_admin
              format.html { redirect_to dropit_admin_mainpage_path(active_tab: 'vendors') }
              format.js { render layout: false }
            else
              format.html { redirect_to location_after_save }
              format.js { render layout: false }
            end
          end
        else
          invoke_callbacks(:create, :fails)
          respond_with(@object) do |format|
            format.html { redirect_to spree.new_dropit_admin_vendor_path } if spree_current_user.has_spree_role? :dropit_admin
            format.html { render action: :new } if spree_current_user.has_spree_role? :admin
            format.js { render layout: false }
          end
        end
      end

      def update
        if permitted_resource_params[:image] && Spree.version.to_f >= 3.6
          @vendor.create_image(attachment: permitted_resource_params.delete(:image))
        end

        invoke_callbacks(:update, :before)
        if @object.update(permitted_resource_params)
          invoke_callbacks(:update, :after)
          respond_with(@object) do |format|
            if spree_current_user.has_spree_role? :dropit_admin
              format.html { redirect_to dropit_admin_mainpage_path(active_tab: 'vendors') }
              format.js { render layout: false }
            else
              format.html { redirect_to location_after_save }
              format.js { render layout: false }
            end
          end
        else
          invoke_callbacks(:update, :fails)
          respond_with(@object) do |format|
            format.html { redirect_to spree.new_dropit_admin_vendor_path } if spree_current_user.has_spree_role? :dropit_admin
            format.html { render action: :new } if spree_current_user.has_spree_role? :admin
            format.js { render layout: false }
          end
        end
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
      
      def destroy
        invoke_callbacks(:destroy, :before)
        if @object.destroy
          invoke_callbacks(:destroy, :after)
          flash[:success] = flash_message_for(@object, :successfully_removed)
        else
          invoke_callbacks(:destroy, :fails)
          flash[:error] = @object.errors.full_messages.join(', ')
        end

        respond_with(@object) do |format|
          if spree_current_user.has_spree_role? :dropit_admin
            format.html { redirect_to dropit_admin_mainpage_path(active_tab: 'vendors') }
            format.js { render layout: false }
          else
            format.html { redirect_to location_after_destroy }
            format.js   { render_js_for_destroy }
          end
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
                      page(params[:page]).
                      per(params[:per_page])
      end
    end
  end
end
