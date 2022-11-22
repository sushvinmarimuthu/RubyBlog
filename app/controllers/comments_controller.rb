class CommentsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  # POST /comments or /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    unless @comment.save
      flash[:notice] = @comment.errors.full_messages.to_s
    end
    redirect_to topic_post_path(params[:topic_id], params[:post_id])
  end

  def destroy
    @comment = Comment.destroy(params[:id])
    if @comment.destroy
      redirect_to topic_post_path(params[:topic_id], params[:post_id])
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:comment).merge(post_id: params[:post_id])
  end
end
