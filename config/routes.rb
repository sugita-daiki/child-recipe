Rails.application.routes.draw do
  get 'recipes/index'
  devise_for :users
  root to: "recipes#index"
end
