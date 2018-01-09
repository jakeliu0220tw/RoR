class CouponDetail < ApplicationRecord
  
  ### class method ###
  
  def self.new_detail(coupon)
    obj = CouponDetail.new
    obj.coupon_code = coupon.coupon_code
    obj.amount = coupon.amount
    obj.created_redeem_count = coupon.created_redeem_count
    obj.redeem_count = coupon.redeem_count
    obj.active = coupon.active
    obj.expiration_date = coupon.expiration_date
    obj.latest_request_user_id = coupon.latest_request_user_id
    obj
  end
  
end
