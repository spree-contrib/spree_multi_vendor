Spree::Admin::UsersController.class_eval do
  private

  def user_params
    params.require(:user).permit(permitted_user_attributes |
                                 [spree_role_ids: [],
                                  vendor_ids: [],
                                  ship_address_attributes: permitted_address_attributes,
                                  bill_address_attributes: permitted_address_attributes])
  end
end
