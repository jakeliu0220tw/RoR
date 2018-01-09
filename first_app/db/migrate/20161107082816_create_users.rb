class CreateUsers < ActiveRecord::Migration

	# create_table() passes a TableDefinition object to the block.
	# This form will not only create the table, but also columns for the
	# table.
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps null: false
    end
  end
end
