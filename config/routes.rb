Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :vendors
    get 'vendor_settings' => 'vendor_settings#edit'
    patch 'vendor_settings' => 'vendor_settings#update'
  end

  get 'vendors/:id/t/*taxon_id', to: 'vendors#show'
  resources :vendors, only: [:show]
end
