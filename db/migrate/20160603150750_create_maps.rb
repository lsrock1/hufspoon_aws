class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.float :lat
      t.float :lon
      t.timestamps null: false
    end
  end
end
