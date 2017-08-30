class RemoveEsperantoToMenulists < ActiveRecord::Migration
  def change
    change_table :menulists do |t|
      t.remove :esperanto
    end
  end
end
