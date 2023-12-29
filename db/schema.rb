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

ActiveRecord::Schema.define(version: 2023_12_29_184244) do

  create_table "challenges", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "started_at", null: false
    t.date "ended_at", null: false
    t.integer "workout_target", null: false
    t.decimal "cost_per_workout", null: false
    t.index ["ended_at"], name: "index_challenges_on_ended_at"
  end

  create_table "people", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", null: false
    t.index ["name"], name: "index_people_on_name", unique: true
  end

  create_table "person_challenges", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "person_id", null: false
    t.integer "challenge_id", null: false
    t.index ["person_id", "challenge_id"], name: "index_person_challenges_on_person_id_and_challenge_id", unique: true
  end

  create_table "workouts", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "occurred_on", null: false
    t.integer "person_challenge_id", null: false
    t.index ["person_challenge_id"], name: "index_workouts_on_person_challenge_id"
  end

  add_foreign_key "person_challenges", "challenges"
  add_foreign_key "person_challenges", "people"
  add_foreign_key "workouts", "person_challenges"
end
