class AddPaypalDetailsToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :payment_token, :string
    add_column :requests, :payerID, :string
  end
end
