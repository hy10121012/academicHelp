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

ActiveRecord::Schema.define(version: 20140928085157) do

  create_table "comments", force: true do |t|
    t.integer  "from_user_id"
    t.text     "comment"
    t.integer  "to_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: true do |t|
    t.string   "country_code"
    t.string   "country_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "currencies", force: true do |t|
    t.string   "currency_code"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "educations", force: true do |t|
    t.string   "name"
    t.integer  "level",      limit: 2, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.integer  "taker_id"
    t.integer  "maker_id",         null: false
    t.integer  "request_id",       null: false
    t.text     "message"
    t.boolean  "is_maker_deleted"
    t.boolean  "is_taker_deleted", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "from_user_id",     null: false
  end

  create_table "payment_histories", force: true do |t|
    t.integer  "user_id"
    t.integer  "request_id"
    t.float    "original_amount"
    t.boolean  "user_pay"
    t.float    "fee_rate"
    t.string   "payment_token"
    t.string   "payerID"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "request_allocations", force: true do |t|
    t.integer  "request_id"
    t.integer  "taker_id"
    t.boolean  "is_success"
    t.boolean  "is_user_cancelled"
    t.boolean  "is_approved"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "request_files", force: true do |t|
    t.integer  "request_id"
    t.integer  "is_deleted",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "description"
    t.boolean  "is_maker_upload"
    t.integer  "user_id"
  end

  create_table "request_logs", force: true do |t|
    t.integer  "request_id"
    t.integer  "user_id"
    t.string   "action"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "value2"
  end

  create_table "request_submits", force: true do |t|
    t.integer  "user_id"
    t.integer  "request_id"
    t.integer  "request_file_id",             null: false
    t.integer  "process",           limit: 2
    t.boolean  "is_latest_version"
    t.boolean  "is_approved"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "request_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requests", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "requirement"
    t.string   "expected_score"
    t.string   "subject"
    t.string   "subject_area_id"
    t.integer  "start_date"
    t.integer  "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "words"
    t.integer  "request_type_id"
    t.integer  "price"
    t.string   "status",          limit: 16
    t.integer  "is_cancel"
    t.string   "cancel_reason"
    t.string   "payment_token"
    t.string   "payerID",         limit: 100
  end

  create_table "subject_areas", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sys_properties", force: true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "universities", force: true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_wirter_university"
  end

  create_table "user_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first"
    t.string   "last"
    t.string   "email"
    t.string   "password"
    t.integer  "education_id"
    t.integer  "university_id"
    t.integer  "country_id"
    t.integer  "user_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
    t.integer  "subject_area_id"
    t.boolean  "is_active"
    t.boolean  "is_validated"
    t.string   "employer"
  end

  create_table "votes", force: true do |t|
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.string   "vote_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "writer_validations", force: true do |t|
    t.integer  "user_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
