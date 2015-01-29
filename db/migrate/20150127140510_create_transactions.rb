class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :subscriber_number
      t.string :amount
      t.string :status

      t.timestamps null: false
    end
  end
end
