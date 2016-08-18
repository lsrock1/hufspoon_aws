class CreateRmenus < ActiveRecord::Migration
  def change
    create_table :rmenus do |t|
      t.string :menuname
      t.string :emenuname
      t.string :content
      t.integer :rest_id
      t.integer :cost
      t.integer :pagenum, default:1
      t.timestamps null: false
    end
  end
end
