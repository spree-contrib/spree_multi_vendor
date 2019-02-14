class AddContactUsToSpreeVendors < SpreeExtension::Migration[4.2]
  def change
    add_column :spree_vendors, :contact_us, :text
  end
end
