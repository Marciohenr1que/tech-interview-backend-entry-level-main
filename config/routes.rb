require 'sidekiq/web'

Rails.application.routes.draw do
  resources :products, only: [:index, :create]

 
  resources :carts, only: [:index, :show, :create, :update] do
    patch :removeproduct, on: :member, to: 'carts#remove_product'
    patch :updatequantity, on: :member, to: 'carts#update_quantity'
    post :addproducttocart, on: :member, to: 'carts#add_product_to_cart' 
  end

  if Rails.env.production? || Rails.env.development?
    mount Sidekiq::Web => '/sidekiq'
  end
end