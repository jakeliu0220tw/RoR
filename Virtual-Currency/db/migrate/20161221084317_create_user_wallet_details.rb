class CreateUserWalletDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :user_wallet_details do |t|
      t.string :user_id
      t.integer :balance
      t.boolean :active
      t.string :comment
      t.text :valid_coupon_codes, array: true
      t.timestamps
    end
  end
end
