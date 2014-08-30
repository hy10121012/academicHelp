class CreateRequestFiles < ActiveRecord::Migration
  def change
    create_table :request_files do |t|
      t.integer :request_id
      t.integer :is_deleted

      t.timestamps
    end
  end
end
