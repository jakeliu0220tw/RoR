class Api::V1::CouponDetailsController < ::ApiController
  
  # GET   /coupon_details/:code
  def show_by_code
    objs = CouponDetail.where(coupon_code: params[:code])
    
    if objs.size == 0
      render :json => { result: "fail", reason: "no match coupon detail object" }, :status => 200
    else
      render :json => { result: "success", coupon_details: objs }, :status => 200
    end
  end
  
end
