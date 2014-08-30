class AddFileToRequest < ActiveRecord::Migration
  def self.up
    change_table :request_files do |t|
      t.attachment :file
    end
  end

  def self.down
    drop_attached_file :request_files, :file
  end
end
