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

ActiveRecord::Schema.define(version: 20170120184237) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "church_groups", force: :cascade do |t|
    t.string   "name"
    t.string   "region"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "email"
    t.integer  "user_id"
  end

  create_table "churches", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "church_group_id"
    t.string   "name"
    t.string   "short_name"
    t.string   "email"
    t.string   "city"
    t.string   "postcode"
    t.string   "address"
    t.date     "date_started"
    t.boolean  "sunday_meeting"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mobile_tokens", force: :cascade do |t|
    t.string   "auth_token"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "records", force: :cascade do |t|
    t.date     "day"
    t.integer  "sunday_att"
    t.integer  "weekday_att"
    t.integer  "first_timers"
    t.integer  "new_converts"
    t.integer  "nbs"
    t.integer  "fnb"
    t.string   "message_sunday"
    t.string   "message_weekday"
    t.string   "preacher_sunday"
    t.string   "preacher_weekday"
    t.integer  "user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "nbs_finish"
    t.boolean  "visitation"
    t.integer  "baptised",         default: 0
    t.integer  "church_id"
  end

  add_index "records", ["day", "church_id"], name: "index_records_on_day_and_church_id", unique: true, using: :btree
  add_index "records", ["user_id"], name: "index_records_on_user_id", using: :btree

  create_table "specials", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.string   "password_digest"
    t.boolean  "admin",           default: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "remember_digest"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "role",            default: "Elder"
  end

  create_table "visitation_records", force: :cascade do |t|
    t.date     "day"
    t.boolean  "visitation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

end
