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
    # required for settings form to submit when password is left blank
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end

    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to root_path
    else
      render "edit"
    end
	end
end
