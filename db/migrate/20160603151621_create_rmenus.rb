class CreateRmenus < ActiveRecord::Migration
  def change
    create_table :rmenus do |t|
      t.string :menuname
      t.text :content
      t.integer :rest_id
      t.timestamps null: false
    end
  end
end
