class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, {:AUTO_INCREMENT=> 100000}  do |t|
      t.string :first
      t.string :last
      t.string :email
      t.string :password
      t.integer :education_id
      t.integer :university_id
      t.integer :country_id
      t.integer :user_type_id
      t.timestamps
    end
  end
end
