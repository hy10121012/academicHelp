class CreateUserReferences < ActiveRecord::Migration
  def change
    create_table :user_references do |t|
      t.integer :referrer_id
      t.integer :referee_id
      t.boolean :is_active

      t.timestamps
    end
  end
end
