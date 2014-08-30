class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.string :vote_type

      t.timestamps
    end
  end
end
