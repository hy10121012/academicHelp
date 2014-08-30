class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :from_user_id
      t.text :comment
      t.integer :to_user_id

      t.timestamps
    end
  end
end
