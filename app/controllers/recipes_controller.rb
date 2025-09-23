class RecipesController < ApplicationController
  def index
    @recipes = if params[:search].present?
                 Recipe.search(params[:search]).recent.includes(:user, :likes, :comments)
               else
                 Recipe.recent.includes(:user, :likes, :comments)
               end
  end

  def new
    @recipe_form = RecipeForm.new
  end

  def create
    @recipe_form = RecipeForm.new(recipe_form_params)
    if @recipe_form.save
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
    return redirect_to recipes_path, alert: '自分のレシピのみ編集できます。' unless @recipe.user == current_user

    @recipe_form = RecipeForm.new(
      title: @recipe.title,
      description: @recipe.description,
      user_id: @recipe.user_id,
      recipe_id: @recipe.id,
      tag_ids: @recipe.tags.pluck(:id)
    )
  end

  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.user == current_user
      @recipe_form = RecipeForm.new(recipe_form_params.merge(user_id: @recipe.user_id, recipe_id: @recipe.id))
      if @recipe_form.update(@recipe)
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

  def recipe_form_params
    params.require(:recipe_form).permit(:title, :description, :image, :new_tag_names, :recipe_id,
                                        tag_ids: []).merge(user_id: current_user.id)
  end
end
