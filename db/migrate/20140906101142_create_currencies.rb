class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :currency_code
      t.integer :country_id

      t.timestamps
    end
  end
end
