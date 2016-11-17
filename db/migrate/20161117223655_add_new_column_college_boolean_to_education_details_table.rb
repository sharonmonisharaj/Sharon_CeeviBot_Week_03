class AddNewColumnCollegeBooleanToEducationDetailsTable < ActiveRecord::Migration[5.0]
  def change
    
    add_column :education_details, :college, :boolean
    
  end
end
