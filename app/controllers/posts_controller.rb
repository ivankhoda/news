class PostsController < ApplicationController
  def index
    @posts = Post.all
    render json: { data: @posts }
  end
end
