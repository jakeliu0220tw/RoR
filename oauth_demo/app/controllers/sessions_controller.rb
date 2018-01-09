class SessionsController < ApplicationController
  def create
	Rails.logger.debug "SessionsController#create"
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to sessions_home_path
  end

  def destroy
	Rails.logger.debug "SessionsController#destroy"
    session[:user_id] = nil
    redirect_to sessions_home_path
  end
  
  def home
	Rails.logger.debug "SessionsController#home"
  end
end
