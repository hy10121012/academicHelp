class AddAttrToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :words, :integer
    add_column :requests, :request_type_id, :integer
    add_column :requests, :price, :integer
    add_column :requests, :status, :string
  end
end
