module SpreeMultiVendor::Spree::Api::V1::UsersControllerDecorator
  private

  def user_params
    params.require(:user).permit(permitted_user_attributes |
                                 [spree_role_ids: [],
                                  vendor_ids: [],
                                  ship_address_attributes: permitted_address_attributes,
                                  bill_address_attributes: permitted_address_attributes])
  end
end

if SpreeMultiVendor::Engine.api_v1_available?
  Spree::Api::V1::UsersController.prepend SpreeMultiVendor::Spree::Api::V1::UsersControllerDecorator
end
