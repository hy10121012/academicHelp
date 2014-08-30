class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests, {:AUTO_INCREMENT=> 100000} do |t|
      t.integer :user_id
      t.string :title
      t.string :requirement
      t.string :expected_score
      t.string :subject
      t.string :subject_area_id
      t.integer :start_date
      t.integer :end_date

      t.timestamps
    end
  end
end
