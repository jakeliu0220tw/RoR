class CreateCoupons < ActiveRecord::Migration[5.0]
  def change
    create_table :coupons do |t|
      t.string :coupon_code
      t.integer :amount
      t.integer :created_redeem_count
      t.integer :redeem_count
      t.boolean :active
      t.datetime :expiration_date
      t.string :latest_request_user_id
      t.timestamps
    end
  end
end
