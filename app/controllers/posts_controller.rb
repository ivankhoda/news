class PostsController < ApplicationController
  def index
    @posts = if params[:from] && params[:to]
               start_date = DateTime.parse(params[:from]).to_time
               end_date = DateTime.parse(params[:to]).to_time
               Post.where(created_at: start_date..end_date).order(created_at: :desc)
             else
               Post.all.order(created_at: :desc)
             end
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
