class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
       facebook_user
    elsif current_user
      UserSession.create(current_user, true)
      redirect_to accounts_url, :notice => "Logged in"
    else
      redirect_to root_url, :flash => {:error => "Not authorized"}
    
      #session["devise.facebook_data"] = request.env["omniauth.auth"]
      #redirect_to new_user_registration_url
    end
 	end

  private 
  
  def auth_hash
    request.env['omniauth.auth']
  end
  def facebook_user
    @current_user = User.find_or_create_from_oauth(auth_hash)
  end
end