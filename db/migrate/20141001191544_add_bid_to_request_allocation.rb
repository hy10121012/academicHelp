class AddBidToRequestAllocation < ActiveRecord::Migration
  def change
    add_column :request_allocations, :bid, :integer
  end
end
