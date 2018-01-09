class Api::V1::CouponsController < ::ApiController
  
  # GET   /coupons/all
  def all
    objs = Coupon.all
    render :json => { result: "success", coupons: objs }, :status => 200
  end
   
  # GET   /coupons/:code
  # get a coupon by coupon_code
  def show_by_code
    obj = Coupon.find_by_coupon_code(params[:code])
    
    if obj.nil?
      render :json => { result: "fail", reason: "no match coupon object" }, :status => 400      
    else
      render :json => { result: "success", coupon: obj }, :status => 200
    end    
  end
  
  # GET   /coupons/active/:active
  # list coupons by active field
  def show_by_active
    objs = Coupon.where(active: eval(params[:active]))
    render :json => { result: "success", coupons: objs }, :status => 200
  end

  # PATCH /coupons/:id
  # PUT   /coupons/:id
  def update
  end
  
  # PATCH /coupons/redeem/:code
  # redeem a coupon by coupon_code
  def redeem
    request_user_id = params[:request_user_id]
    obj = Coupon.find_by_coupon_code(params[:code])

    if obj.nil?
      render :json => { result: "fail", reason: "coupon code is invalid" }, :status => 400
      return
    end
    
    if obj.redeem(request_user_id) && CouponDetail.new_detail(obj).save
      render :json => { result: "success", coupon: obj }, :status => 200        
    else
      render :json => { result: "fail", reason: "redeem fail" }, :status => 400
    end
  end
  
  # POST  /coupons
  def create
    coupon_attrs = params.require(:coupon).permit(:amount, :created_redeem_count, :redeem_count, :active, :expiration_date)
    obj = Coupon.new(coupon_attrs)
    
    if obj.save && CouponDetail.new_detail(obj).save
      render :json => { result: "success", coupon: obj }, :status => 200
    else
      render :json => { result: "fail", reason: "create coupon obj fail" }, :status => 400
    end
  end
  
end
