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

ActiveRecord::Schema[7.2].define(version: 2024_11_03_234528) do
  create_table "addresses", force: :cascade do |t|
    t.integer "establishment_id", null: false
    t.string "street_name", null: false
    t.integer "street_number", null: false
    t.string "neighborhood", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "country", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["establishment_id"], name: "index_addresses_on_establishment_id"
  end

  create_table "business_hours", force: :cascade do |t|
    t.integer "establishment_id", null: false
    t.integer "day_of_week"
    t.string "status"
    t.time "open_time"
    t.time "close_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["establishment_id"], name: "index_business_hours_on_establishment_id"
  end

  create_table "establishments", force: :cascade do |t|
    t.string "trade_name", null: false
    t.string "legal_name", null: false
    t.string "business_national_id", null: false
    t.string "phone", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id", null: false
    t.string "code"
    t.index ["business_national_id"], name: "index_establishments_on_business_national_id", unique: true
    t.index ["email"], name: "index_establishments_on_email", unique: true
    t.index ["owner_id"], name: "index_establishments_on_owner_id"
    t.index ["phone"], name: "index_establishments_on_phone", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.string "lastname", null: false
    t.string "personal_national_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "establishment_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["establishment_id"], name: "index_users_on_establishment_id"
    t.index ["personal_national_id"], name: "index_users_on_personal_national_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "addresses", "establishments"
  add_foreign_key "business_hours", "establishments"
  add_foreign_key "establishments", "users", column: "owner_id"
end
