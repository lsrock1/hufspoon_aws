class AddKeywordToCurates < ActiveRecord::Migration
  def change
    change_table :curates do |t|
      t.string :keyword
    end
  end
end
