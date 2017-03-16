class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :transaction_id
      t.string :buyer
      t.string :buyer_name
      t.string :amount
      t.string :fees
      t.string :mac
      t.string :offer_title
      t.string :buyer_phone
      t.string :currency
      t.string :status

      t.timestamps null: false
      
    end
  end
end
