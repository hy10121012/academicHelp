class CreateUniversities < ActiveRecord::Migration
  def change
    create_table :universities do |t|
      t.string :name
      t.integer :country_id
      t.integer :level
      t.boolean :is_writer_university

      t.timestamps
    end
  end
end
