class UsersController < ApplicationController
	
	

	def index
		@user = User.find(params[:id])
	end

	def show
		@user = User.find(params[:id]) 
	end
	def edit
		@user = User.find(params[:id])
		authorize! :update, @user 
	end

	def update
    @user = User.find(params[:id])
      if @user.update_attributes(params[:user])
         redirect_to @user, notice: 'user was successfully updated.' 
      else
         render  "edit" 
      end
	end
end
