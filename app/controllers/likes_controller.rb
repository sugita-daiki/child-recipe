class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipe

  def create
    like = current_user.likes.build(recipe: @recipe)
    like.save
    redirect_to recipe_path(@recipe)
  end

  def destroy
    like = current_user.likes.find_by(id: params[:id], recipe: @recipe)
    like&.destroy
    redirect_to recipe_path(@recipe)
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end
end
