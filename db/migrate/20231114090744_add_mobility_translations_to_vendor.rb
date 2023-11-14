class AddMobilityTranslationsToVendor < ActiveRecord::Migration[6.1]
  def change
    if ActiveRecord::Base.connection.table_exists?('spree_vendor_translations')
      if ActiveRecord::Migration.connection.index_exists?(:spree_vendors_translations, :spree_vendor_id)
        remove_index :spree_vendor_translations, column: :spree_vendor_id, if_exists: true
      end
    else
      create_table :spree_vendor_translations do |t|
        # Translated attribute(s)
        t.string :name
        t.text :about_us
        t.text :contact_us
        t.string :slug

        t.string  :locale, null: false
        t.references :spree_vendor, null: false, foreign_key: true, index: false

        t.timestamps null: false
      end

      add_index :spree_vendor_translations, :locale, name: :index_spree_vendor_translations_on_locale
      add_index :spree_vendor_translations, [:locale, :slug], unique: true, name: 'vendor_unique_slug_per_locale'
    end
  end
end
