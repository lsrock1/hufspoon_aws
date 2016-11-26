class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :num
      t.string :name
      t.string :level
      t.text :content
      t.string :title
      t.string :ip
      t.timestamps null: false
    end
  end
end
