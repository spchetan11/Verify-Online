class CreateVerificationRequests < ActiveRecord::Migration
  def change
    create_table :verification_requests do |t|
      t.references :user
      t.references :college
      t.references :payment
      t.references :verification_status, default: 1
      
      t.string :verification_token
      t.string :name
      t.string :hallticket_no
      t.string :document_link
      t.float :amount
      t.float :service_tax

      t.string :course              
      t.string :type_of_studies    
      t.string :course_duration		
      t.string :remarks				
      t.string :class_awarded
      		
      t.string :payment_slug
      
      t.timestamps null: false
    end
  end
end
