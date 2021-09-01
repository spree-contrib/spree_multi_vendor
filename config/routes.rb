Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :vendors do
      collection do
        post :update_positions
      end
    end
    get 'vendor_settings' => 'vendor_settings#edit'
    patch 'vendor_settings' => 'vendor_settings#update'
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v2 do
      namespace :storefront do
        resources :vendors, only: [:show]
      end
    end
    namespace :v1 do
      resources :vendors
    end
  end
end
