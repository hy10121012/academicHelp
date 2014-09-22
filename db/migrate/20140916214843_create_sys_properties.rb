class CreateSysProperties < ActiveRecord::Migration
  def change
    create_table :sys_properties do |t|
      t.string :name
      t.string :value

      t.timestamps
    end


    SysProperty.create(:name=>"maker_rate",:value=>'0.05')
    SysProperty.create(:name=>"taker_rate",:value=>'0.05')

  end
end
