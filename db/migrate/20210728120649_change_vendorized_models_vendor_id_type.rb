class ChangeVendorizedModelsVendorIdType < ActiveRecord::Migration[4.2]
  def change
    SpreeMultiVendor.vendorized_models.each do |klass|
      change_column klass.table_name, :vendor_id, :bigint
    rescue
      message = "Could not change vendor_id column for spree_#{klass}"
      Rails.logger.error message
    end
  end
end
