class AddEsperantoToMenulists < ActiveRecord::Migration
  def change
    change_table :menulists do |t|
      t.string :esperanto
    end
  end
end
