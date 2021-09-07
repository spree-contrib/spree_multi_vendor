class AddSocialToSpreeVendors < SpreeExtension::Migration[4.2]
  def change
    add_column :spree_vendors, :facebook, :string
    add_column :spree_vendors, :twitter, :string
    add_column :spree_vendors, :instagram, :string
  end
end