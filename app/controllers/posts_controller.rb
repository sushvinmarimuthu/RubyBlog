class PostsController < ApplicationController
  load_and_authorize_resource except: :user_post_read_status
  before_action :authenticate_user!
  before_action :set_topic
  before_action :set_post, only: %i[edit update destroy]
  skip_before_action :verify_authenticity_token
  skip_authorization_check only: :user_post_read_status

  # GET /posts or /posts.json
  def index
    if params[:from_date] and params[:to_date]
      @from_date = params[:from_date]
      @to_date = params[:to_date]
    else
      @from_date = Date.yesterday.strftime('%Y-%m-%d')
      @to_date = Date.today.strftime('%Y-%m-%d')
    end

    @posts = if params[:topic_id]
               @topic.posts.includes([:image_attachment => :blob], :user, :topic, :posts_tags, :tags, :comments, :users_posts).references(:users_posts).paginate(page: params[:page], per_page: 10)
             else
               Post.includes([:users_posts, :image_attachment => :blob], :topic, :user, :posts_tags, :tags, :comments).references(:users_posts).paginate(page: params[:page], per_page: 10).with_from_to(@from_date, @to_date).order('posts.created_at DESC')
             end
    @post = if params[:topic_id]
              @topic.posts.build
            else
              Post.new
            end
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post = Post.find(params[:id])
    @rating = Rating.find_by_post_id(params[:id])
  end


  # GET /posts/new
  def new
    @post = if params[:topic_id]
              @topic.posts.build
            else
              Post.new
            end
  end

  # GET /posts/1/edit
  def edit; end

  # POST /posts or /posts.json
  def create
    @post = if params[:topic_id]
              @topic.posts.build(post_params)
            else
              Post.new(post_params)
            end
    @post.user_id = current_user.id
    respond_to do |format|
      if @post.save
        if params[:topic_id]
          format.html { redirect_to topic_posts_path }
          format.js
        else
          format.html { redirect_to posts_path }
          format.js
        end
      else
        format.json { render :json => @post.errors.full_messages , status: :unprocessable_entity }
        format.js
      end
    end
  end

  def user_post_read_status
    user = User.find_by(id: current_user.id)
    post = Post.find_by(id: params[:id])
    unless post.users_posts.include?(current_user)
      user.users_posts << post
    end
    # head :ok
    respond_to do |format|
      if params[:topic_id]
        format.html { redirect_to topic_post_path(params[:topic_id], params[:id]) }
        format.js { render :nothing => true }
      else
        format.html { redirect_to post_url(params[:id]) }
        format.js
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        if params[:topic_id]
          format.html { redirect_to [@topic, :posts], notice: 'Post was successfully updated.' }
        else
          format.html { redirect_to post_url(@post), notice: 'Post was successfully updated.' }
        end
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      if params[:topic_id]
        format.html { redirect_to [@topic, :posts], notice: 'Post was successfully destroyed.' }
      else
        format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      end
      format.json { head :no_content }
    end
  end

  private

  def set_topic
    # @topic = Topic.find(params[:topic_id]) if params[:topic_id].present?
    @topic = if params[:topic_id]
               Topic.find(params[:topic_id])
             else
               Topic.all
             end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = if params[:topic_id]
              @topic.posts.find(params[:id])
            else
              Post.find(params[:id])
            end
  end

  # Only allow a list of trusted parameters through.
  def post_params
    if params[:topic_id]
      params.require(:post).permit(:title, :image, :description, :all_tags)
    else
      params.require(:post).permit(:title, :image, :description, :topic_id, :all_tags)
    end
  end
end
