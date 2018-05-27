class AddTurkishToMenulists < ActiveRecord::Migration
  def change
    change_table :menulists do |t|
      t.string :turkish
    end
  end
end
