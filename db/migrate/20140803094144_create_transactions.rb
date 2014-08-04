class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
    	t.string :name
    	t.integer :price
    	t.integer :quantity
    	t.integer :subtotal

      t.timestamps
    end
  end
end
