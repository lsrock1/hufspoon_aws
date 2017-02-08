class AddPictureToRmenus < ActiveRecord::Migration
  def change
    change_table :rmenus do |t|
      t.string :picture, default: ""
    end
  end
end
