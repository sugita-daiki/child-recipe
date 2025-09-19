class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    if @recipe.save
      redirect_to recipes_path, notice: 'レシピが正常に投稿されました！'
    else
      render :new
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :description, :image).merge(user_id: current_user.id)
  end
end
