class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :user_id
      t.string :name
      t.string :provider
      t.string :token
      t.timestamps
    end
  end
end
