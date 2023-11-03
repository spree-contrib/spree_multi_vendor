module Spree
  module Admin
    module MainMenu
      class OrganizationBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          item = ::Spree::Admin::MainMenu::ItemBuilder.new('vendors', admin_vendors_path).
                 with_availability_check(->(ability, _store) { ability.can?(:manage, ::Spree::Vendor) && ability.can?(:index, ::Spree::Vendor) }).
                 with_label_translation_key('vendors').
                 with_match_path('/vendors').
                 build

          ::Spree::Admin::MainMenu::SectionBuilder.new('organizations', 'building.svg').
            with_label_translation_key('organizations').
            with_item(item).
            build
        end
      end
    end
  end
end

Rails.application.config.after_initialize do
  if Spree::Core::Engine.backend_available?
    Rails.application.config.spree_backend.main_menu.insert_before('users', ::Spree::Admin::MainMenu::OrganizationBuilder.new.build)
  end
end
