class AddCmenunameToRmenus < ActiveRecord::Migration
  def change
    change_table :rmenus do |t|
      t.string :cmenuname, default: ""
    end
  end
end
