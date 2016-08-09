class CreateLunch2s < ActiveRecord::Migration
  def change
    create_table :lunch2s do |t|

      t.timestamps null: false
      t.integer :date
      t.string :menu
    end
  end
end
