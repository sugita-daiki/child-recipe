class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
    @recipes = [] if @recipes.nil?
  end

  def new
    @recipe = Recipe.new
  end
end
