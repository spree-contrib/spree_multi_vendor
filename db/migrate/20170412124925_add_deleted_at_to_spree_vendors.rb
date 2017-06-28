class AddDeletedAtToSpreeVendors < SpreeExtension::Migration[4.2]
  def change
    add_column :spree_vendors, :deleted_at, :datetime
    add_index :spree_vendors, :deleted_at
  end
end
