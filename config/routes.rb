Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    match '/recipes/search_and_save', to: 'recipes#search', via: :get
    match '/recipes/get_by_ids', to: 'recipes#get_by_ids', via: :post

    resources :rates, only: [:create]
  end

end
