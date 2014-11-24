class CreateUserSubjectLinks < ActiveRecord::Migration
  def change
    create_table :user_subject_links do |t|
      t.integer :user_id
      t.integer :subject_area_id

      t.timestamps
    end
  end
end
