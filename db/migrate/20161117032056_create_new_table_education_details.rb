class CreateNewTableEducationDetails < ActiveRecord::Migration[5.0]
  def change
    
    create_table :education_details do |t|
      t.string :program
      t.string :institute
      t.datetime :completed_on
      t.string :score
    end
    
  end
end
