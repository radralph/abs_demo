class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :msisdn
      t.string :token
      t.string :unsubscribed

      t.timestamps null: false
    end
  end
end
