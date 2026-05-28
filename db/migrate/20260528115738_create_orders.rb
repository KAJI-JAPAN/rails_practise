class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.integer    :status,   null: false, default: 0   # enum: pending/shipped/...
      t.decimal    :total,    precision: 10, scale: 2

      t.timestamps
    end
  end
end
