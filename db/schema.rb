# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_15_114135) do

  create_table "patients", force: :cascade do |t|
    t.string "fullname"
    t.string "npp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "spms", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.string "spm_base"
    t.string "spm_mirror"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "study_date"
    t.index ["patient_id"], name: "index_spms_on_patient_id"
  end

  add_foreign_key "spms", "patients"
end
