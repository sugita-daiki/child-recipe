class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipe

  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        CommentChannel.broadcast_to @recipe, { comment: @comment, user: @comment.user }
        format.html { redirect_to @recipe, notice: 'コメントを投稿しました' }
        format.json { render json: { status: 'success', message: 'コメントを投稿しました' } }
      else
        format.html { redirect_to @recipe, alert: 'コメントの投稿に失敗しました' }
        format.json { render json: { status: 'error', errors: @comment.errors.full_messages } }
      end
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def comment_params
    return {} unless user_signed_in?

    params.require(:comment).permit(:content).merge(user_id: current_user.id, recipe_id: params[:recipe_id])
  end
end
