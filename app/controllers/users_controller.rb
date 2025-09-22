class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @recipes = @user.recipes.recent.includes(:likes, :comments)
    @liked_recipes = @user.liked_recipes.recent.includes(:user, :likes, :comments)
  end
end
