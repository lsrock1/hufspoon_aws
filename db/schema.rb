# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160903145111) do

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true

  create_table "breakfasts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "date"
    t.string   "menu"
  end

  create_table "comments", force: :cascade do |t|
    t.string   "num"
    t.string   "name"
    t.string   "level"
    t.text     "content"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "curates", force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "address"
    t.string   "keyword"
    t.integer  "show",       default: 0
  end

  create_table "dinners", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "date"
    t.string   "menu"
  end

  create_table "fdinners", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "date"
    t.string   "menu"
  end

  create_table "flunches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "date"
    t.string   "menu"
  end

  create_table "lunch1s", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "date"
    t.string   "menu"
  end

  create_table "lunch2s", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "date"
    t.string   "menu"
  end

  create_table "lunchnoodles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "date"
    t.string   "menu"
  end

  create_table "maps", force: :cascade do |t|
    t.float    "lat"
    t.float    "lon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menuas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "date"
    t.string   "menu"
  end

  create_table "menubs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "date"
    t.string   "menu"
  end

  create_table "menulists", force: :cascade do |t|
    t.string   "kname"
    t.string   "ername"
    t.string   "ename"
    t.string   "jnamea"
    t.string   "cname"
    t.string   "cnameb"
    t.string   "aname"
    t.string   "spanish"
    t.string   "germany"
    t.string   "italia"
    t.string   "portugal"
    t.string   "u_picture"
    t.integer  "u_like",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string   "num"
    t.string   "name"
    t.string   "level"
    t.text     "content"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rests", force: :cascade do |t|
    t.integer  "map_id"
    t.string   "name"
    t.string   "food"
    t.string   "page"
    t.string   "picture"
    t.string   "re_menu"
    t.string   "ere_menu"
    t.string   "address"
    t.string   "phone"
    t.string   "open"
    t.integer  "count",      default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "rmenus", force: :cascade do |t|
    t.integer  "rest_id"
    t.string   "menuname"
    t.string   "emenuname"
    t.string   "content"
    t.integer  "cost"
    t.integer  "category"
    t.integer  "pagenum",    default: 1
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "snacks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "date"
    t.string   "menu"
  end

  create_table "users", force: :cascade do |t|
    t.string   "key"
    t.integer  "language"
    t.integer  "count"
    t.string   "country"
    t.integer  "chat_room"
    t.integer  "step"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
