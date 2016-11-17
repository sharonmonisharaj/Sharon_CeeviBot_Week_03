class CreateNewTableProjects < ActiveRecord::Migration[5.0]
  def change
    
    create_table :projects do |t|
      t.string :title
      t.string :description
      t.string :url
    end
    
  end
end
