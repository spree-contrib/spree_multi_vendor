module SpreeMultiVendor::Spree::Api::V1::VariantsControllerDecorator
  private

  def scope
    variants = if @product
                  @product.variants_including_master
                else
                  Spree::Variant
                end

    if current_ability.can?(:manage, Spree::Variant) && params[:show_deleted]
      variants = variants.with_deleted
    end

    variants = variants.for_vendor_user(current_spree_user) unless @current_user_roles.include?('admin')
    variants = variants.eligible if Spree.version.to_f >= 3.7

    variants.accessible_by(current_ability, :read)
  end
end

Spree::Api::V1::VariantsController.prepend SpreeMultiVendor::Spree::Api::V1::VariantsControllerDecorator
