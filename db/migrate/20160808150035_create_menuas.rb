class CreateMenuas < ActiveRecord::Migration
  def change
    create_table :menuas do |t|

      t.timestamps null: false
      t.integer :date
      t.string :menu
    end
  end
end
