class UserCommentRatingController < ApplicationController
  before_action :authenticate_user!
  def show
    @comment_ratings = UserCommentRating.where(comment_id: params[:id])
  end
  def create
    @comment_rating = UserCommentRating.new(rating_params)
    @comment_rating.user_id = current_user.id
    unless @comment_rating.save
      flash[:notice] = @comment_rating.errors.full_messages.to_s
    end
    redirect_to topic_post_path(params[:topic_id], params[:post_id])
  end

  private
  def rating_params
    params.require(:user_comment_rating).permit(:rate).merge(comment_id: params[:user_comment_rating][:comment_id])
  end
end
