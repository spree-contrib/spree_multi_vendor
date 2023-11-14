module SpreeMultiVendor
  module Admin
    module Tabs
      class VendorTabsBuilder
        include ::Spree::Core::Engine.routes.url_helpers

        def build
          root = ::Spree::Admin::Tabs::Root.new
          add_details_tab(root)
          add_translations_tab(root)
          root
        end

        private

        def add_details_tab(root)
          tab = ::Spree::Admin::Tabs::TabBuilder.new('details', ->(resource) { edit_admin_vendor_path(resource) }).
                  with_icon_key('edit.svg').
                  with_active_check.
                  with_availability_check(->(ability, resource) { ability.can?(:edit, resource) }).
                  build

          root.add(tab)
        end

        def add_translations_tab(root)
          tab = ::Spree::Admin::Tabs::TabBuilder.new('translations', ->(resource) { translations_admin_vendor_path(resource) }).
                  with_icon_key('translate.svg').
                  with_active_check.
                  with_availability_check(
                    lambda do |ability, resource|
                      ability.can?(:edit, resource) && !resource.deleted?
                    end
                  ).
                  build

          root.add(tab)
        end
      end
    end
  end
end
