class CreateRests < ActiveRecord::Migration
  def change
    create_table :rests do |t|
      t.integer :map_id
      t.string :name
      t.string :food#레스토랑 종류
      t.string :page #메뉴분류
      t.string :picture #나중에 사진
      t.string :re_menu #대표메뉴
      t.string :ere_menu#영어 대표메뉴
      t.string :address #주소
      t.string :phone #번호
      t.string :open #영업시간
      t.integer :count, default: 0
      t.timestamps null: false
    end
  end
end
