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

  def show
    @recipe = Recipe.find(params[:id])
    @comments = @recipe.comments.includes(:user)
    @comment = Comment.new
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    if @recipe.user == current_user
      @recipe.destroy
      redirect_to recipes_path, notice: 'レシピを削除しました。'
    else
      redirect_to recipes_path, alert: '自分のレシピのみ削除できます。'
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :description, :image).merge(user_id: current_user.id)
  end
end
