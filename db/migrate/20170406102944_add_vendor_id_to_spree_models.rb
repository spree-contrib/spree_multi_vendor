class AddVendorIdToSpreeModels < SpreeExtension::Migration[4.2]
  def change
    table_names = %w[
      option_types
      properties
      products
      stock_locations
      shipping_methods
      variants
    ]

    table_names.each do |table_name|
      add_reference "spree_#{table_name}", :vendor, index: true
    end
  end
end
