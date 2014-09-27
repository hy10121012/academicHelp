class CreateWriterValidations < ActiveRecord::Migration
  def change
    create_table :writer_validations do |t|
      t.integer :user_id
      t.attachment :file
      t.timestamps
    end
  end
end
