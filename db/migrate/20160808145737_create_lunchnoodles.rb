class CreateLunchnoodles < ActiveRecord::Migration
  def change
    create_table :lunchnoodles do |t|

      t.timestamps null: false
      t.integer :date
      t.string :menu
    end
  end
end
