class CreateNewTableWorkDetails < ActiveRecord::Migration[5.0]
  def change
    
    create_table :work_details do |t|
      t.string :job_title
      t.string :company
      t.datetime :started_on
      t.datetime :completed_on
      t.string :job_description
      t.string :location
    end
    
  end
end
