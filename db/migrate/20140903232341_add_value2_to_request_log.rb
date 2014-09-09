class AddValue2ToRequestLog < ActiveRecord::Migration
  def change
    add_column :request_logs, :value2, :integer
  end
end
