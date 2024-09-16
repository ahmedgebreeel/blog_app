class PostsController < ApplicationController
    before_action :authorize_request
    before_action :set_post, only: [:show, :update, :destroy]
    before_action :authorize_author, only: [:update, :destroy]
  
    def index
      @posts = Post.all
      render json: @posts
    end
  
    def show
      render json: @post
    end
  
    def create
      @post = @current_user.posts.build(post_params)
      if @post.save
        DeletePostJob.set(wait: 24.hours).perform_later(@post.id)
        render json: @post, status: :created
      else
        render json: @post.errors, status: :unprocessable_entity
      end
    end
  
    def update
      if @post.update(post_params)
        render json: @post
      else
        render json: @post.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      @post.destroy
      head :no_content
    end
  
    private
  
    def set_post
      @post = Post.find(params[:id])
    end
  
    def authorize_author
      render json: { error: 'Not authorized' }, status: :unauthorized unless @post.user_id == @current_user.id
    end
  
    def post_params
      params.require(:post).permit(:title, :body, :tags)
    end
  end
  