class AddChineseToRests < ActiveRecord::Migration
  def change
    change_table :rests do |t|
      t.string :chinese, default: ""
    end
  end
end
