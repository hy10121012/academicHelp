class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :from_user_id
      t.integer :taker_id
      t.integer :maker_id
      t.integer :request_id
      t.text :message
      t.boolean :is_taker_deleted
      t.boolean :is_maker_deleted

      t.timestamps
    end
  end
end
