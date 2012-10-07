class PostsController < ApplicationController
	def index
		@posts = Post.order("created_at DESC")
		@post = Post.new
	end
	def show
		@post = Post.find(params[:id])
		
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
end
