class CreateNewTableSkills < ActiveRecord::Migration[5.0]
  def change
    
    create_table :skills do |t|
      t.string :title
      t.string :description
    end
    
  end
end
