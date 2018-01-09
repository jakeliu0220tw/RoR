class AddImgUrlIntoProduct < ActiveRecord::Migration[5.0]
  def change
    change_table :products do |t|
      t.string :imgurl
    end    
  end
end
