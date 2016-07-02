class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :num
      t.string :name
      t.string :level
      t.text :content
      t.integer :post_id
      t.timestamps null: false
    end
  end
end
