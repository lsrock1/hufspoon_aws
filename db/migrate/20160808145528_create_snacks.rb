class CreateSnacks < ActiveRecord::Migration
  def change
    create_table :snacks do |t|

      t.timestamps null: false
      t.integer :date
      t.string :menu
    end
  end
end
