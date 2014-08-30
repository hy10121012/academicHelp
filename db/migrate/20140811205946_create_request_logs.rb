class CreateRequestLogs < ActiveRecord::Migration
  def change
    create_table :request_logs do |t|
      t.integer :request_id
      t.integer :user_id
      t.string :action
      t.string :value

      t.timestamps
    end
  end
end
