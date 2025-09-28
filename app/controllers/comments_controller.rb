class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipe
  before_action :set_comment, only: [:destroy]
  before_action :ensure_comment_owner, only: [:destroy]

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

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @recipe, notice: 'コメントを削除しました' }
      format.json { render json: { status: 'success', message: 'コメントを削除しました' } }
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def set_comment
    @comment = @recipe.comments.find(params[:id])
  end

  def ensure_comment_owner
    return if @comment.user == current_user

    redirect_to @recipe, alert: 'このコメントを削除する権限がありません'
  end

  def comment_params
    return {} unless user_signed_in?

    params.require(:comment).permit(:content).merge(user_id: current_user.id, recipe_id: params[:recipe_id])
  end
end
