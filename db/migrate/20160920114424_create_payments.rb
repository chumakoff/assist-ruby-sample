class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.decimal :amount, precision: 8, scale: 2
      t.integer :status, null: false, default: 0
      t.string :billnumber

      t.timestamps
    end
  end
end
