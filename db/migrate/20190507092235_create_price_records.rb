class CreatePriceRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :price_records do |t|
      t.datetime :effective_from
      t.float :monthly_price
      t.float :joining_fee
    end
  end
end
