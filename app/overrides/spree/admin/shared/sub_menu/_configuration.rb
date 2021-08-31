  Deface::Override.new(
  virtual_path: 'spree/admin/shared/sub_menu/_configuration',
  name: 'Remove review setting option from vendor panner',
  replace: 'erb[loud]:contains("review_settings")',
  text: '<%= configurations_sidebar_menu_item(Spree.t(:review_settings, scope: :spree_reviews), edit_admin_review_settings_path) if can? :manage, Spree::Review %>'
)