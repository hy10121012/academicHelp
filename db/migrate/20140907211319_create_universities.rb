class CreateUniversities < ActiveRecord::Migration
  def change
    create_table :universities do |t|
      t.string :name
      t.integer :country_id
      t.integer :level

      t.timestamps
    end
  end
end
