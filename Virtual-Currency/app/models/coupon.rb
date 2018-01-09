class Coupon < ApplicationRecord

  # set default value of Coupon obj
  after_initialize do |obj|
    obj.coupon_code = SecureRandom.hex if obj.coupon_code.nil?
    obj.amount = 0 if obj.amount.nil?
    obj.created_redeem_count = 100 if obj.created_redeem_count.nil?
    obj.redeem_count = obj.created_redeem_count if obj.redeem_count.nil?
    obj.active = true if obj.active.nil?
    obj.expiration_date = DateTime.new(2099, 12, 31, 23, 59, 59) if obj.expiration_date.nil?
  end
  
  ### class method ###
  
  def self.valid?(code)
    obj = Coupon.find_by_coupon_code(code)
    return false if obj.nil?
    return false if obj.active == false
    return false if obj.redeem_count < 1
    return false if obj.expiration_date < Time.now
    
    true
  end
  
  
  ### instance method ###
  def IsValid?
    return false if self.active == false
    return false if self.redeem_count < 1
    return false if self.expiration_date < Time.now
    
    true
  end
  
      
  def redeem(request_user_id = nil)
    if self.active == true && self.redeem_count > 0 && self.expiration_date >= Time.now 
      self.redeem_count = self.redeem_count - 1
      self.latest_request_user_id = request_user_id
      
      self.save!
    else
      return false
    end
  end
end
