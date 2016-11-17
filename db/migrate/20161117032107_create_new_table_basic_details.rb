class CreateNewTableBasicDetails < ActiveRecord::Migration[5.0]
  def change
    
    create_table :basic_details do |t|
      t.string :title
      t.string :description
    end
    
  end
end
