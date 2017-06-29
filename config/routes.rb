Spree::Core::Engine.routes.draw do
  resources :egift_cards
  namespace :admin do
    resources :egift_cards
  end

  namespace :api, defaults: { format: 'json' } do
  	namespace :v1 do
  		resources :egift_cards
  	end
  end

end
