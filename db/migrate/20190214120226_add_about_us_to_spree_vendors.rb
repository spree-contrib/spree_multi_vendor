class AddAboutUsToSpreeVendors < SpreeExtension::Migration[4.2]
  def change
    add_column :spree_vendors, :about_us, :text
  end
end
