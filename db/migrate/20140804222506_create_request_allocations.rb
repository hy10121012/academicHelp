class CreateRequestAllocations < ActiveRecord::Migration
  def change
    create_table :request_allocations do |t|
      t.integer :request_id
      t.integer :taker_id
      t.boolean :is_success
      t.boolean :is_user_cancelled
      t.boolean :is_approved

      t.timestamps
    end
  end
end
