class AddDescriptionToRequestFile < ActiveRecord::Migration
  def change
    add_column :request_files, :description, :string
  end
end
