Rails.application.routes.draw do
  get 'recipes/index'
  devise_for :users
  root to: "recipes#index"
  resources :recipes, only: [:index, :new, :create, :show] do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: :create

  end

end
