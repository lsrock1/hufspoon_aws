class CreateRmenus < ActiveRecord::Migration
  def change
    create_table :rmenus do |t|
      t.integer :rest_id
      t.string :menuname
      t.string :emenuname
      t.string :content
     
      t.integer :cost
      t.integer :category
      t.integer :pagenum, default:1
      t.timestamps null: false
    end
  end
end
