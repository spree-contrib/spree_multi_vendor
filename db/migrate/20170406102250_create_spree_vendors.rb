class CreateSpreeVendors < SpreeExtension::Migration[4.2]
  def change
    create_table :spree_vendors do |t|
      t.string :name
      t.timestamps
    end
    add_index :spree_vendors, :name, unique: true
  end
end
