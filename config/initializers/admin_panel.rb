Rails.application.config.after_initialize do
  if Spree::Core::Engine.backend_available?
    Rails.application.config.spree_backend.main_menu.insert_before('users', ::SpreeMultiVendor::Admin::MainMenu::OrganizationBuilder.new.build)

    Rails.application.config.spree_backend.tabs[:vendor] = ::SpreeMultiVendor::Admin::Tabs::VendorTabsBuilder.new.build
  end
end
