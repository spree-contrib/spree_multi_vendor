Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :vendors
  end
end
