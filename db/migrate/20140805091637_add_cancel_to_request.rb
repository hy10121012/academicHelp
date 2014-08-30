class AddCancelToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :is_cancel, :integer
    add_column :requests, :cancel_reason, :string
  end
end
