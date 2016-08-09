class CreateLunch1s < ActiveRecord::Migration
  def change
    create_table :lunch1s do |t|

      t.timestamps null: false
      t.integer :date
      t.string :menu
    end
  end
end
