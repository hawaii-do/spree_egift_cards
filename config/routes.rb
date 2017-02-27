Spree::Core::Engine.routes.draw do
  resources :egift_cards
  namespace :admin do
    resources :egift_cards
  end
end
