class AddFieldsToCurates < ActiveRecord::Migration
  def change
    change_table :curates do |t|
      t.date :startDate, null: false, default: Time.now
      t.date :endDate, default: 30.days.from_now
      t.string :dayOfWeek, default: "8"
      t.string :time, default: "00"
    end
  end
end
