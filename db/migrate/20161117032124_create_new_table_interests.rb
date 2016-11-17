class CreateNewTableInterests < ActiveRecord::Migration[5.0]
  def change
    
    create_table :interests do |t|
      t.string :title
      t.string :description
    end
    
  end
end
