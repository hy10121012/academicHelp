class AddSubjectAreaIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :subject_area_id, :integer
  end
end
