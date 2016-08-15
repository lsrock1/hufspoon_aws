class CreateRests < ActiveRecord::Migration
  def change
    create_table :rests do |t|
      t.integer :map_id
      t.string :name
      t.string :food#레스토랑 종류
      t.string :famous #대표메뉴
      t.string :page #메뉴분류
      t.integer :count, default: 0
      t.timestamps null: false
    end
  end
end
