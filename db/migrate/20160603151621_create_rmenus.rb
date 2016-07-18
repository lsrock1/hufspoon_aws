class CreateRmenus < ActiveRecord::Migration
  def change
    create_table :rmenus do |t|
      t.string :menuname
      t.text :content
      t.integer :rest_id
      t.integer :cost
      t.integer :pagenum, default:0
      t.timestamps null: false
    end
  end
end
