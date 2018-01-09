class Api::V1::UserWalletDetailsController < ::ApiController
  
  # GET   /user_wallet_details/:user_id
  # get a UserWalletDetail by user_id
  def show_by_user_id
    objs = UserWalletDetail.where(user_id: params[:user_id])
    
    if objs.size == 0
      render :json => { result: "fail", reason: "no match UserWalletDetail objects" }, :status => 200
    else
      render :json => { result: "success", user_wallet_details: objs }, :status => 200
    end
  end
  
end
