class CreatePaymentHistories < ActiveRecord::Migration
  def change
    create_table :payment_histories do |t|
      t.integer :user_id
      t.integer :request_id
      t.float :original_amount
      t.boolean :user_pay
      t.float :fee_rate
      t.string :payment_token
      t.string :payerID

      t.timestamps
    end
  end
end
