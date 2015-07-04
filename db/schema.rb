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

ActiveRecord::Schema.define(version: 20150703142734) do

  create_table "notes", force: :cascade do |t|
    t.string   "uid",            limit: 255,                             null: false
    t.integer  "trip_id",        limit: 4,                               null: false
    t.string   "title",          limit: 255
    t.string   "slug",           limit: 255
    t.text     "content",        limit: 65535
    t.decimal  "longitude",                    precision: 15, scale: 10
    t.decimal  "latitude",                     precision: 15, scale: 10
    t.integer  "image_changed",  limit: 4
    t.integer  "note_timestamp", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture",        limit: 255
  end

  add_index "notes", ["slug"], name: "index_notes_on_slug", unique: true, using: :btree
  add_index "notes", ["trip_id"], name: "idx_notes_trip", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "trips", force: :cascade do |t|
    t.string   "uid",        limit: 255,                  null: false
    t.integer  "user_id",    limit: 4,                    null: false
    t.boolean  "public",     default: true, null: false
    t.string   "title",      limit: 255,                  null: false
    t.string   "slug",       limit: 255
    t.text     "content",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trips", ["slug"], name: "index_trips_on_slug", unique: true, using: :btree
  add_index "trips", ["user_id"], name: "idx_trips_user", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "type",       limit: 255, null: false
    t.string   "identifier", limit: 255, null: false
    t.string   "secret",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       limit: 255
    t.string   "avatar",     limit: 255
  end

end
