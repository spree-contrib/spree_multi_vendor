Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :vendors
    get 'vendor_settings' => 'vendor_settings#edit'
    patch 'vendor_settings' => 'vendor_settings#update'
  end
end
