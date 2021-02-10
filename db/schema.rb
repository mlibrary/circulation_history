# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_09_194645) do

  create_table "loans", id: :string, charset: "utf8mb4", force: :cascade do |t|
    t.string "user_uniqname", null: false
    t.string "title"
    t.string "author"
    t.string "mms_id"
    t.datetime "return_date"
    t.datetime "checkout_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_uniqname"], name: "index_loans_on_user_uniqname"
  end

  create_table "users", primary_key: "uniqname", id: :string, charset: "utf8mb4", force: :cascade do |t|
    t.boolean "retain_history", default: false
    t.boolean "confirmed", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "loans", "users", column: "user_uniqname", primary_key: "uniqname"
end
