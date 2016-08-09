class CreateDinners < ActiveRecord::Migration
  def change
    create_table :dinners do |t|

      t.timestamps null: false
      t.integer :date
      t.string :menu
    end
  end
end
