Spree::Admin::OptionTypesController.class_eval do
  before_action :set_vendor_id, only: [:create, :update]
end
