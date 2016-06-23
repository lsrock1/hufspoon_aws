class CreateMenulists < ActiveRecord::Migration
  def change
    create_table :menulists do |t|
      t.string :kname
      t.string :ername
      t.string :ename
      t.string :cname
      t.string :aname
      t.timestamps null: false
    end
  end
end
