class CreateVerificationStatuses < ActiveRecord::Migration
  def change
    create_table :verification_statuses do |t|
      t.string :description

      t.timestamps null: false
    end
  end
end
