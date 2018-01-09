class UserWalletDetail < ApplicationRecord
  
  ### class method ###
  
  def self.new_detail(wallet)
    obj = UserWalletDetail.new
    obj.user_id = wallet.user_id
    obj.balance = wallet.balance
    obj.active = wallet.active
    obj.comment = wallet.comment
    obj.valid_coupon_codes = wallet.valid_coupon_codes
    obj
  end
  
end
