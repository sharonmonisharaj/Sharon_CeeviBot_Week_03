class CreateNewTableAwards < ActiveRecord::Migration[5.0]
  def change
    
    create_table :awards do |t|
      t.string :title
      t.string :description
      t.datetime :awarded_on
    end
    
  end
end
