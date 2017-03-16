class CreateReportData < ActiveRecord::Migration
  def change
    create_table :report_data do |t|
      t.references :college, index: true, foreign_key: true
      t.text :from_address
      t.text :to_address
      t.string :letter_title
      t.string :subject
      t.text :body
      t.text :designation
      t.has_attached_file :header
      t.has_attached_file :signature

      t.timestamps null: false
    end
  end
end
