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

ActiveRecord::Schema.define(version: 2021_06_27_232225) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "copart_lots", force: :cascade do |t|
    t.string "lot_number"
    t.datetime "sale_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "aasm_state"
    t.string "name"
    t.string "vin"
    t.string "primary_damage"
    t.string "secondary_damage"
    t.integer "year"
    t.string "make"
    t.string "model"
    t.string "doc_type"
    t.string "odometer"
    t.string "engine_type"
    t.string "location"
    t.bigint "vehicle_id"
    t.boolean "purchased", default: false
    t.index ["vehicle_id"], name: "index_copart_lots_on_vehicle_id"
  end

  create_table "expense_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.text "description"
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "expense_type", default: "debit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "currency", default: "USD", null: false
    t.decimal "usd_amount", precision: 10, scale: 2
    t.string "category", default: "", null: false
    t.decimal "rate", precision: 10, scale: 5, default: "1.0", null: false
    t.index ["owner_type", "owner_id"], name: "index_expenses_on_owner"
  end

  create_table "holodilnic_sensors_data", force: :cascade do |t|
    t.decimal "humidity_top"
    t.decimal "temperature_top_c"
    t.decimal "humidity_bottom"
    t.decimal "temperature_bottom_c"
    t.datetime "created_at", precision: 6, null: false
  end

  create_table "house_logs", force: :cascade do |t|
    t.string "level"
    t.string "source"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "screenshot"
  end

  create_table "photos", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "photo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_type", "owner_id"], name: "index_photos_on_owner_type_and_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "name"
    t.string "vin"
    t.integer "year"
    t.string "make"
    t.string "model"
    t.string "engine_type"
    t.integer "odometer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "copart_lots", "vehicles"
end
