class CreateFdinners < ActiveRecord::Migration
  def change
    create_table :fdinners do |t|

      t.timestamps null: false
      t.integer :date
      t.string :menu
    end
  end
end
