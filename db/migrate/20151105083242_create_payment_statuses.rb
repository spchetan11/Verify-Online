class CreatePaymentStatuses < ActiveRecord::Migration
  def change
    create_table :payment_statuses do |t|
      t.string :description	
      t.timestamps null: false
    end
  end
end
