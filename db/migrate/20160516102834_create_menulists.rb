class CreateMenulists < ActiveRecord::Migration
  def change
    create_table :menulists do |t|
      t.string :kname , unique: true
      t.string :ername
      t.string :ename
      t.string :jnamea#훈독
      t.string :cname#간체
      t.string :cnameb#번체
      t.string :aname
      t.string :spanish
      t.string :germany
      t.string :italia
      t.string :portugal
      t.integer :u_like, default: 0
      t.timestamps null: false
    end
  end
end
