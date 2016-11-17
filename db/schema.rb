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

ActiveRecord::Schema.define(version: 20161117223655) do

  create_table "awards", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "awarded_on"
  end

  create_table "basic_details", force: :cascade do |t|
    t.string "title"
    t.string "description"
  end

  create_table "education_details", force: :cascade do |t|
    t.string   "program"
    t.string   "institute"
    t.datetime "completed_on"
    t.string   "score"
    t.string   "location"
    t.boolean  "college"
  end

  create_table "interests", force: :cascade do |t|
    t.string "title"
    t.string "description"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "url"
  end

  create_table "skills", force: :cascade do |t|
    t.string "title"
    t.string "description"
  end

  create_table "work_details", force: :cascade do |t|
    t.string   "job_title"
    t.string   "company"
    t.datetime "started_on"
    t.datetime "completed_on"
    t.string   "job_description"
    t.string   "location"
    t.boolean  "internship"
  end

end
