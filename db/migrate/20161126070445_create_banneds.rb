class CreateBanneds < ActiveRecord::Migration
  def change
    create_table :banneds do |t|
      
      t.string :identity
      t.integer :number
      t.string :ip

      t.timestamps null: false
    end
  end
end
