class VideosController < ApplicationController
	def index
		@video = Video.new
		if params[:tag]
			@videos = Video.tagged_with(params[:tag]).page(params[:page]).per(5)
			else
			@videos = Video.order("created_at DESC").page(params[:page]).per(5)
		end
	end

	def create
		@video = Video.new(params[:video])
		@video = current_user.videos.create(params[:video])
	
		if @video.save
			flash[:notice] = "Picture has been save"
			redirect_to proc { video_url(@video) }
		else
			 render "new"
		end
	end

	def edit
		@video = Video.find(params[:id])
		authorize! :update, @video
	end

	def update
		@video = Video.find(params[:id])
  		if @video.update_attributes(params[:video])
  			flash[:notice] = "video has been updated"
			redirect_to proc { video_url(@video) }
		else
			render "edit"
  		end
		
	end

	def show
		@video = Video.find(params[:id])
		
	end

	def destroy
     @video = Video.find(params[:id])
     	@video.destroy
     	redirect_to current_user, notice: "Successfully destroyed video."
     	authorize! :destroy, @video
  	end
  	private
  	
end
