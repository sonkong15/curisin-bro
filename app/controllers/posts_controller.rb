class PostsController < ApplicationController
	def index
		@post = Post.new
		if params[:tag]
			@posts = Post.tagged_with(params[:tag]).page(params[:page]).per(5)
			else
			@posts = Post.order("created_at DESC").page(params[:page]).per(5)
		end
		
	end
	def show
		@post = Post.find(params[:id])
		@posts = Post.order("RANDOM()").limit(4)
		
	end
	def create
		@post = Post.new(params[:post])
		@post = current_user.posts.create(params[:post])
	
		if @post.save
			flash[:notice] = "Picture has been save"
			redirect_to proc { post_url(@post) }
		else
			 render "new"
		end
	end
	def edit
      @post = Post.find(params[:id]) 
      authorize! :update, @post
  	end

  	def update 
  		@post = Post.find(params[:id])
  		if @post.update_attributes(params[:post])
  			flash[:notice] = "Picture has been updated"
			redirect_to proc { post_url(@post) }
		else
			render "edit"
  		end
  	end

	def destroy
     @post = Post.find(params[:id])
     	@post.destroy
     	redirect_to current_user, notice: "Successfully destroyed Post."
     	authorize! :destroy, @post
  	end
end
