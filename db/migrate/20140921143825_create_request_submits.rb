class CreateRequestSubmits < ActiveRecord::Migration
  def change
    create_table :request_submits do |t|
      t.integer :user_id
      t.integer :request_id
      t.integer :request_file_id
      t.integer :process
      t.boolean :is_latest_version
      t.boolean :is_approved
      t.timestamps
    end
  end
end
