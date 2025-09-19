Rails.application.routes.draw do
  get 'recipes/index'
  devise_for :users
  root to: "recipes#index"
  resources :recipes, only: [:index, :new, :create, :show] do
    resource :likes, only: [:create, :destroy]
  end

end
