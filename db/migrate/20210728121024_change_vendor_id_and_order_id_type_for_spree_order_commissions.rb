class ChangeVendorIdAndOrderIdTypeForSpreeOrderCommissions < ActiveRecord::Migration[4.2]
  def up
    change_table(:spree_order_commissions) do |t|
      t.change :vendor_id, :bigint
      t.change :order_id, :bigint
    end
  end
  def down
    change_table(:spree_order_commissions) do |t|
      t.change :vendor_id, :integer
      t.change :order_id, :integer
    end
  end
end
