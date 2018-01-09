class UserWallet < ApplicationRecord
  
  serialize :valid_coupon_codes, Array
  
  # set default value of UserWallet obj
  after_initialize do |obj|
    obj.balance = 0 if obj.balance.nil? 
    obj.active = true if obj.active.nil?
  end  
  
  ### class method ###
  
  def self.check_init_hash(init_hash)
    return false if init_hash[:user_id].nil?
    
    # one user_id only has one UserWallet obj
    wallets = UserWallet.where(user_id: init_hash[:user_id])
    return false if wallets.size > 1

    # coupon codes should be valid
    if !init_hash[:valid_coupon_codes].nil? && init_hash[:valid_coupon_codes].size > 0 
      init_hash[:valid_coupon_codes].each { |code| return false if Coupon.valid?(code) == false }
    end
    
    true
  end
  
  ### instance method ###
  
  def toggle_off(toggle_hash)
    return false if toggle_hash[:user_id].nil? || self.user_id != toggle_hash[:user_id]

    self.active = toggle_hash[:active]
    self.comment = toggle_hash[:comment]

    save!
  end
  
  def recharge(recharge_hash)
    return false if recharge_hash[:user_id].nil? || self.user_id != recharge_hash[:user_id]
    return false if recharge_hash[:amount].to_i < 0
    return false if self.active == false

    self.balance = self.balance + recharge_hash[:amount].to_i
    self.comment = recharge_hash[:comment]
      
    save!
  end
  
  def withdraw(withdraw_hash)
    return false if withdraw_hash[:user_id].nil? || self.user_id != withdraw_hash[:user_id]
    return false if withdraw_hash[:amount].to_i < 0
    return false if self.active == false
    return false if self.balance < withdraw_hash[:amount].to_i.abs

    self.balance = self.balance - withdraw_hash[:amount].to_i
    self.comment = withdraw_hash[:comment]

    save!
  end
  
  def add_coupons(add_hash)
    return false if add_hash[:user_id].nil? || self.user_id != add_hash[:user_id]
    return false if add_hash[:coupon_codes].size == 0
    return false if self.active == false
    add_hash[:coupon_codes].each { |code| return false if Coupon.valid?(code) == false }
    
    # add coupon codes into array
    self.valid_coupon_codes = self.valid_coupon_codes + add_hash[:coupon_codes] 
    self.valid_coupon_codes.uniq!
    
    save!
  end
  
  def remove_coupons(remove_hash)
    return false if remove_hash[:user_id].nil? || self.user_id != remove_hash[:user_id]
    return false if remove_hash[:coupon_codes].size == 0
    return false if self.active == false
    
    # remove coupon codes from array
    self.valid_coupon_codes = self.valid_coupon_codes - remove_hash[:coupon_codes]
    self.valid_coupon_codes.uniq!
    
    save!
  end

  def payment(payment_hash)
    pay_rules_ary = ['use_wallet_only', 'use_coupon_only', 'use_coupon_first']
    return false if payment_hash[:user_id].nil? || self.user_id != payment_hash[:user_id]
    return false if payment_hash[:amount].to_i < 0
    return false if payment_hash[:pay_rule].nil? || pay_rules_ary.include?(payment_hash[:pay_rule]) == false

    case payment_hash[:pay_rule]
    when 'use_wallet_only'
      return payment_use_wallet_only(payment_hash[:amount].to_i)
    when 'use_coupon_only'
      return payment_use_coupon_only(payment_hash[:amount].to_i)
    when 'use_coupon_first'
      return payment_use_coupon_only(payment_hash[:amount].to_i) || payment_use_wallet_only(payment_hash[:amount].to_i)
    end
    
    false
  end
  
  private

  def payment_use_wallet_only(amount)
    return false if self.balance < amount
        
    self.balance = self.balance - amount    
    self.save!
  end  

  def payment_use_coupon_only(amount)
    # establish coupon_obj_ary
    coupon_obj_ary = []
    self.valid_coupon_codes.each do |code|
      obj = Coupon.find_by_coupon_code(code)
      coupon_obj_ary << obj if obj.IsValid? 
    end
    
    # sorting coupon_obj_ary by expiration date
    coupon_obj_ary.sort! { |x, y| x.expiration_date <=> y.expiration_date }    

    # reset valid_coupon_codes[]
    self.valid_coupon_codes.clear    

    # redeem first satisfied coupon and rebuild valid_coupon_codes[]
    use_coupon = false
    coupon_obj_ary.each do |obj|
      if use_coupon == false && amount <= obj.amount
        # redeem satisfied coupon
        use_coupon = obj.redeem(self.user_id) && CouponDetail.new_detail(obj).save
        self.valid_coupon_codes << obj.coupon_code if use_coupon == false
      else
        self.valid_coupon_codes << obj.coupon_code
      end
    end
    
    return self.save! && use_coupon == true
  end
  
end
