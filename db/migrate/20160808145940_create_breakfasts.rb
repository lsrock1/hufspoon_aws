class CreateBreakfasts < ActiveRecord::Migration
  def change
    create_table :breakfasts do |t|

      t.timestamps null: false
      t.integer :date
      t.string :menu
    end
  end
end
