class RatingsController < ApplicationController
  before_action :authenticate_user!
  def create
    @rating = Rating.new(rating_params)
    @rating.user_id = current_user.id

    unless @rating.save
      flash[:notice] = @rating.errors.full_messages.to_s
    end
    redirect_to topic_post_path(params[:topic_id], params[:post_id])
  end

  private
  def rating_params
    params.require(:rating).permit(:rate).merge(post_id: params[:post_id])
  end
end
