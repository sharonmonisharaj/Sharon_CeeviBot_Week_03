class AddNewColumnBooleanInternshipToWorkDetailsTable < ActiveRecord::Migration[5.0]
  def change
    
    add_column :work_details, :internship, :boolean
    
  end
end
