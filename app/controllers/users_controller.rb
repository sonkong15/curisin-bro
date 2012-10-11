class UsersController < ApplicationController
	before_filter :authenticate_user!
	
	def new
		
	end

	def create
		
	end

	def index
		
	end

	def show
		@user = User.find(params[:id]) 
	end
	def edit
		@user = User.find(params[:id]) 
	end
end
