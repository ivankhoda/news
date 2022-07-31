class PostsController < ApplicationController
  def index
    @posts = Post.all.sort_by(&:created_at)
    render json: { data: @posts }
  end

  def show
    @post = Post.find_by(id: params[:id])
    if @post
      render json: @post
    else
      render json :@post.errors
    end
  end
end
