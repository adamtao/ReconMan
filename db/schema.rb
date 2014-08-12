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

ActiveRecord::Schema.define(version: 20140801231907) do

  create_table "branches", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.integer  "state_id"
    t.string   "zipcode"
    t.string   "phone"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "branches", ["client_id"], name: "index_branches_on_client_id", using: :btree

  create_table "client_products", force: true do |t|
    t.integer  "client_id"
    t.integer  "product_id"
    t.integer  "price_cents",    default: 0,     null: false
    t.string   "price_currency", default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_products", ["client_id"], name: "index_client_products_on_client_id", using: :btree
  add_index "client_products", ["product_id"], name: "index_client_products_on_product_id", using: :btree

  create_table "clients", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "counties", force: true do |t|
    t.string   "name"
    t.integer  "state_id"
    t.string   "search_url"
    t.string   "search_params"
    t.string   "search_method"
    t.string   "average_days_to_complete"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "counties", ["state_id"], name: "index_counties_on_state_id", using: :btree

  create_table "job_products", force: true do |t|
    t.integer  "product_id"
    t.integer  "job_id"
    t.integer  "price_cents",    default: 0,     null: false
    t.string   "price_currency", default: "USD", null: false
    t.string   "workflow_state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_search_at"
    t.string   "search_url"
    t.date     "due_on"
  end

  add_index "job_products", ["job_id"], name: "index_job_products_on_job_id", using: :btree
  add_index "job_products", ["product_id"], name: "index_job_products_on_product_id", using: :btree

  create_table "jobs", force: true do |t|
    t.integer  "client_id"
    t.string   "address"
    t.string   "city"
    t.integer  "state_id"
    t.string   "zipcode"
    t.integer  "county_id"
    t.datetime "completed_at"
    t.string   "old_owner"
    t.string   "new_owner"
    t.string   "workflow_state"
    t.integer  "requestor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "parcel_number"
  end

  add_index "jobs", ["client_id"], name: "index_jobs_on_client_id", using: :btree
  add_index "jobs", ["county_id"], name: "index_jobs_on_county_id", using: :btree
  add_index "jobs", ["parcel_number"], name: "index_jobs_on_parcel_number", using: :btree
  add_index "jobs", ["requestor_id"], name: "index_jobs_on_requestor_id", using: :btree

  create_table "products", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "price_cents",     default: 0,     null: false
    t.string   "price_currency",  default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default"
    t.boolean  "performs_search"
  end

  create_table "states", force: true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "due_within_days"
  end

  create_table "title_search_caches", force: true do |t|
    t.integer  "job_product_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "title_search_caches", ["job_product_id"], name: "index_title_search_caches_on_job_product_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "role"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.integer  "branch_id"
  end

  add_index "users", ["branch_id"], name: "index_users_on_branch_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end