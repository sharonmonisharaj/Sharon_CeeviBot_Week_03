class AddColumnLocationToEducationDetailsTable < ActiveRecord::Migration[5.0]
  def change
    
    add_column :education_details, :location, :string
    
  end
end
