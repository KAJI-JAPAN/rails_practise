class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string     :title,          null: false
      t.references :author,         null: false, foreign_key: true
      t.boolean    :out_of_print,   null: false, default: false
      t.integer    :status,         null: false, default: 0   # enum: available/unavailable/...
      t.integer    :year_published
      t.integer    :views,          null: false, default: 0
      t.decimal    :price,          precision: 8, scale: 2

      t.timestamps
    end
  end
end
