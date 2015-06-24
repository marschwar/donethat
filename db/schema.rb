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

ActiveRecord::Schema.define(version: 20131010112254) do

  create_table "notes", force: true do |t|
    t.string   "uid",                                      null: false
    t.integer  "trip_id",                                  null: false
    t.string   "title"
    t.string   "slug"
    t.text     "content"
    t.decimal  "longitude",      precision: 15, scale: 10
    t.decimal  "latitude",       precision: 15, scale: 10
    t.string   "image_uid"
    t.integer  "image_changed"
    t.integer  "note_timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["slug"], name: "index_notes_on_slug", unique: true, using: :btree
  add_index "notes", ["trip_id"], name: "idx_notes_trip", using: :btree

  create_table "trips", force: true do |t|
    t.string   "uid",                       null: false
    t.integer  "user_id",                   null: false
    t.boolean  "public",     default: true, null: false
    t.string   "title",                     null: false
    t.string   "slug"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trips", ["slug"], name: "index_trips_on_slug", unique: true, using: :btree
  add_index "trips", ["user_id"], name: "idx_trips_user", using: :btree

  create_table "users", force: true do |t|
    t.string   "type",       null: false
    t.string   "identifier", null: false
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "avatar_uid"
  end

end
