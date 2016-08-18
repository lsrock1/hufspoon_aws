class CreateCurates < ActiveRecord::Migration
  def change
    create_table :curates do |t|

      t.timestamps null: false
      t.string :address
      t.string :keyword
      t.integer :show , default:0
    end
  end
end
