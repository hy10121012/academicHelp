class AddActiveToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_active, :boolean
    add_column :users, :is_validated, :boolean
  end
end
