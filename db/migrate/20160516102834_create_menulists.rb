class CreateMenulists < ActiveRecord::Migration
  def change
    create_table :menulists do |t|
      t.string :kname
      t.string :ername
      t.string :ename
      t.string :jnamea#훈독
      t.string :cname#간체
      t.string :cnameb#번체
      t.string :aname
      t.timestamps null: false
    end
  end
end
