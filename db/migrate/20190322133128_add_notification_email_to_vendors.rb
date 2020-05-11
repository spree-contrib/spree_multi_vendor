class AddNotificationEmailToVendors < SpreeExtension::Migration[4.2]
  def change
    add_column :spree_vendors, :notification_email, :string
  end
end
