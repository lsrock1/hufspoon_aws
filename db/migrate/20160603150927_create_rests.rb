class CreateRests < ActiveRecord::Migration
  def change
    create_table :rests do |t|
      t.integer :map_id
      t.string :name
      t.string :food
      t.integer :count, default: 0
      t.timestamps null: false
    end
  end
end
