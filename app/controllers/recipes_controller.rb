class RecipesController < ApplicationController
  def index
    @recipes = if params[:search].present?
                 Recipe.search(params[:search]).recent.includes(:user, :likes, :comments)
               else
                 Recipe.recent.includes(:user, :likes, :comments)
               end
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

  def edit
    @recipe = Recipe.find(params[:id])
    return unless @recipe.user != current_user

    redirect_to recipes_path, alert: '自分のレシピのみ編集できます。'
  end

  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.user == current_user
      if @recipe.update(recipe_params)
        redirect_to @recipe, notice: 'レシピを更新しました。'
      else
        render :edit
      end
    else
      redirect_to recipes_path, alert: '自分のレシピのみ編集できます。'
    end
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
