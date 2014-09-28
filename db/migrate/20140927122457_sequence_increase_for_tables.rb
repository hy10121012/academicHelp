class SequenceIncreaseForTables < ActiveRecord::Migration
  def up
    execute "ALTER TABLE  `users` AUTO_INCREMENT =1000006"
    execute "ALTER TABLE  `requests` AUTO_INCREMENT =1000000"
  end

  def down

  end
end
