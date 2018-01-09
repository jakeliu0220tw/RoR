class Api::V1::UserWalletsController < ::ApiController
  
  # GET   /user_wallets/all
  def all
    objs = UserWallet.all
    render :json => { result: "success", wallets: objs }, :status => 200
  end
   
  # GET   /user_wallets/:user_id
  # get a UserWallet by user_id
  def show_by_user_id
    obj = UserWallet.find_by_user_id(params[:user_id])
    
    if obj.nil?
      render :json => { result: "fail", reason: "no match user wallet object" }, :status => 200
    else
      render :json => { result: "success", wallet: obj }, :status => 200
    end
  end
  
  # GET   /user_wallets/active/:active
  # list UserWallets by active field
  def show_by_active
    objs = UserWallet.where(active: eval(params[:active]))
    render :json => { result: "success", wallets: objs }, :status => 200
  end

  # PATCH /user_wallets/:id
  # PUT   /user_wallets/:id
  def update
  end

  # PATCH /user_wallets/recharge
  def recharge
    wallet_attrs = params.require(:user_wallet).permit(:user_id, :amount, :comment)
    
    obj = UserWallet.find_by_user_id(wallet_attrs[:user_id])
    if obj.nil?
      render :json => { result: "fail", reason: "no match UserWallet object" }, :status => 400
      return
    end
    
    if obj.recharge(wallet_attrs) && UserWalletDetail.new_detail(obj).save
      render :json => { result: "success", wallet: obj }, :status => 200
    else
      render :json => { result: "fail", reason: "update UserWallet object fail" }, :status => 400
    end
  end

  # PATCH /user_wallets/withdraw
  def withdraw
    wallet_attrs = params.require(:user_wallet).permit(:user_id, :amount, :comment)
    
    obj = UserWallet.find_by_user_id(wallet_attrs[:user_id])
    if obj.nil?
      render :json => { result: "fail", reason: "no match UserWallet object" }, :status => 400
      return
    end
    
    if obj.withdraw(wallet_attrs) && UserWalletDetail.new_detail(obj).save
      render :json => { result: "success", wallet: obj }, :status => 200
    else
      render :json => { result: "fail", reason: "update UserWallet object fail" }, :status => 400
    end
  end  
      
  # PATCH /user_wallets/toggle_off
  # enable or disable A UserWallet
  def toggle_off
    wallet_attrs = params.require(:user_wallet).permit(:user_id, :active, :comment)
    
    obj = UserWallet.find_by_user_id(wallet_attrs[:user_id])
    if obj.nil?
      render :json => { result: "fail", reason: "no match UserWallet object" }, status => 400
      return
    end
    
    if obj.toggle_off(wallet_attrs) && UserWalletDetail.new_detail(obj).save
      render :json => { result: "success", wallet: obj }, :status => 200
    else
      render :json => { result: "fail", reason: "update UserWallet object fail" }, status => 200
    end
  end
  
  # POST  /user_wallets
  def create
    wallet_attrs = params.require(:user_wallet).permit(:user_id, :balance, :active, :comment, :valid_coupon_codes => [])
    unless UserWallet.check_init_hash(wallet_attrs)
      render :json => { result: "fail", reason: "params is invalid!" }, :status => 200
      return
    end

    obj = UserWallet.new(wallet_attrs)
    if obj.save && UserWalletDetail.new_detail(obj).save
      render :json => { result: "success", wallet: obj }, :status => 200
    else
      render :json => { result: "fail", reason: "create UserWallet object fail" }, :status => 400
    end
  end
    
  # POST /user_wallets/add_coupons
  def add_coupons
    wallet_attrs = params.require(:user_wallet).permit(:user_id, :comment, :coupon_codes => [])
      
    obj = UserWallet.find_by_user_id(wallet_attrs[:user_id])
    if obj.nil?
      render :json => { result: "fail", reason: "no match UserWallet object" }, status => 400
      return
    end
    
    if obj.add_coupons(wallet_attrs) && UserWalletDetail.new_detail(obj).save
      render :json => { result: "success", wallet: obj }, :status => 200
    else
      render :json => { result: "fail", reason: "add coupons into UserWallet object fail" }, :status => 400
    end
  end
  
  # POST /user_wallets/remove_coupons
  def remove_coupons
    wallet_attrs = params.require(:user_wallet).permit(:user_id, :comment, :coupon_codes => []) 
      
    obj = UserWallet.find_by_user_id(wallet_attrs[:user_id])
    if obj.nil?
      render :json => { result: "fail", reason: "no match UserWallet object" }, status => 400
      return
    end
    
    if obj.remove_coupons(wallet_attrs) && UserWalletDetail.new_detail(obj).save
      render :json => { result: "success", wallet: obj }, :status => 200
    else
      render :json => { result: "fail", reason: "remove coupons from UserWallet object fail" }, :status => 400
    end
  end
  
  # POST /user_wallets/payment
  # payment by coupon & wallet, based on the payment rule
  def payment
    wallet_attrs = params.require(:user_wallet).permit(:user_id, :amount, :pay_rule, :comment)
    
    obj = UserWallet.find_by_user_id(wallet_attrs[:user_id])
    if obj.nil?
      render :json => { result: "fail", reason: "no match UserWallet object" }, status => 400
      return
    end    
    
    if obj.payment(wallet_attrs) && UserWalletDetail.new_detail(obj).save
      render :json => { result: "success", wallet: obj }, :status => 200
    else
      render :json => { result: "fail", reason: "payment with UserWallet object fail" }, :status => 400
    end
  end
end
