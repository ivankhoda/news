class PostController < ApplicationController
  def store
    # upload image to cloudinary
    @value = Cloudinary::Uploader.upload(params[:image])
    # create a new post object and save to db
    @post = Post.new({ link: @value['secure_url'], caption: params[:caption] })
    @post.save
    # trigger an event with pusher
    if @post.save
      # broadcasting posts using pusher
      Pusher.trigger('posts-channel', 'new-post', {
                       link: @post.link,
                       caption: @post.caption
                     })
    end
    redirect_to('/')
  end

  def index
    @posts = Post.all
  end
end
