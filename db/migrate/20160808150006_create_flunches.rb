class CreateFlunches < ActiveRecord::Migration
  def change
    create_table :flunches do |t|

      t.timestamps null: false
      t.integer :date
      t.string :menu
    end
  end
end
