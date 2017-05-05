class AddVendorIdToSpreeOrders < ActiveRecord::Migration
  def change
    add_reference :spree_orders, :vendor, index: true
  end
end
