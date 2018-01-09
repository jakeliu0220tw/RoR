class ApiController < ActionController::Base

  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user
  
  private
  
  def authenticate_user
#    user_token = request.header['X-USER-TOKEN']
#    if user_token
#      @user = User.find_by_token(user_token)
#      if @user.nil?
#        return unauthorize
#      end
#    else
#      return unauthorize
#    end
    true
  end
  
  def unauthorize
    head status: 401
    return false
  end
end
