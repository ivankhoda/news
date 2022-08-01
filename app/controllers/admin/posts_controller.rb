module Admin
  class PostsController < Admin::ApplicationController
    protect_from_forgery with: :null_session
    def create
      p params.keys, params, 'PARAMS'
      @value = Cloudinary::Uploader.upload(params[:post][:link])
      @post = Post.new({ link: @value['secure_url'], title: params[:post][:title], content: params[:post][:content] })
      @post.save
      if @post.save
        Pusher.trigger('posts-channel', 'new-post', {
                         link: @post.link, title: @post.title, content: @post.content
                       })
      end
      redirect_to('/admin')
    end

    def update
      @post = Post.where(id: params[:id])
      @value = if params[:post][:link]
                 Cloudinary::Uploader.upload(params[:post][:link])['secure_url']
               else
                 @value = @post.as_json[0]['link']
               end
      @post.update({ link: @value, title: params[:post][:title], content: params[:post][:content],
                     visible: params[:post][:visible] })
      Pusher.trigger('posts-channel', 'post-update', { data: @post })

      redirect_to('/admin')
    end

    def destroy
      @post = Post.find_by(id: params[:id])
      if @post.delete
        Pusher.trigger('posts-channel', 'post-delete', { data: params[:id] })
      else
        render json: { message: @conversation.errors }
      end

      redirect_to('/admin')
    end

    # Override this method to specify custom lookup behavior.
    # This will be used to set the resource for the `show`, `edit`, and `update`
    # actions.
    #
    # def find_resource(param)
    #   Foo.find_by!(slug: param)
    # end

    # The result of this lookup will be available as `requested_resource`

    # Override this if you have certain roles that require a subset
    # this will be used to set the records shown on the `index` action.
    #
    # def scoped_resource
    #   if current_user.super_admin?
    #     resource_class
    #   else
    #     resource_class.with_less_stuff
    #   end
    # end

    # Override `resource_params` if you want to transform the submitted
    # data before it's persisted. For example, the following would turn all
    # empty values into nil values. It uses other APIs such as `resource_class`
    # and `dashboard`:
    #
    # def resource_params
    #   params.require(resource_class.model_name.param_key).
    #     permit(dashboard.permitted_attributes).
    #     transform_values { |value| value == "" ? nil : value }
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
    # private

    def permitted_params
      params.require(:post).permit(:title, :content, :image)
    end
  end
end
