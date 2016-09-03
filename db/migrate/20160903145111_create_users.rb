class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :key
      t.integer :language
      t.integer :count
      t.string :country
      t.integer :chat_room
      t.integer :step
      t.timestamps null: false
    end
  end
end
