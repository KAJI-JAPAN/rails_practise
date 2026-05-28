class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.string  :first_name,   null: false
      t.string  :last_name,    null: false
      t.integer :orders_count, null: false, default: 0

      t.timestamps
    end
  end
end
