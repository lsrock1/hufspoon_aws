class CreateMenubs < ActiveRecord::Migration
  def change
    create_table :menubs do |t|

      t.timestamps null: false
      t.integer :date
      t.string :menu
    end
  end
end
