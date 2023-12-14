class AddVendorIdToSpreeOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_orders, :vendor_id, :bigint
  end
end
