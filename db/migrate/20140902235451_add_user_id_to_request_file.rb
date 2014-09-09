class AddUserIdToRequestFile < ActiveRecord::Migration
  def change
    add_column :request_files, :is_maker_upload, :boolean
    add_column :request_files, :user_id, :integer
  end
end
