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

ActiveRecord::Schema.define(version: 20140624010702) do

  create_table "educations", force: true do |t|
    t.integer  "founder_id"
    t.string   "school"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "founders", force: true do |t|
    t.integer  "startup_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "linkedin_url"
    t.integer  "connections"
  end

  add_index "founders", ["startup_id"], name: "index_founders_on_startup_id"

  create_table "jobs", force: true do |t|
    t.integer  "founder_id"
    t.string   "position"
    t.string   "company"
    t.string   "company_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "startups", force: true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "accelerator"
    t.string   "angellist_url"
  end

end
