Rails.application.routes.draw do
  # static home page
  root to: 'pages#show', id: 'index'
  # using high_voltage for static pages
  get '/pages/*id' => 'pages#show', as: :page, format: false

  # products controller with repository pattern
  resources :products do
    patch 'reorder', on: :member
  end

  # products controller with fat model
  resources :inventories do
    patch 'reorder', on: :member
  end
end
