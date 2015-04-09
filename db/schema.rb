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

ActiveRecord::Schema.define(version: 20150409151633) do

  create_table "branches", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "address",        limit: 255
    t.string   "city",           limit: 255
    t.integer  "state_id",       limit: 4
    t.string   "zipcode",        limit: 255
    t.string   "phone",          limit: 255
    t.integer  "client_id",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "headquarters",   limit: 1,   default: false
    t.integer  "created_by_id",  limit: 4
    t.integer  "modified_by_id", limit: 4
  end

  add_index "branches", ["client_id"], name: "index_branches_on_client_id", using: :btree

  create_table "client_products", force: :cascade do |t|
    t.integer  "client_id",      limit: 4
    t.integer  "product_id",     limit: 4
    t.integer  "price_cents",    limit: 4,   default: 0,     null: false
    t.string   "price_currency", limit: 255, default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id",  limit: 4
    t.integer  "modified_by_id", limit: 4
  end

  add_index "client_products", ["client_id"], name: "index_client_products_on_client_id", using: :btree
  add_index "client_products", ["product_id"], name: "index_client_products_on_product_id", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "client_type",      limit: 255
    t.string   "website",          limit: 255
    t.string   "billing_address",  limit: 255
    t.string   "billing_city",     limit: 255
    t.integer  "billing_state_id", limit: 4
    t.string   "billing_zipcode",  limit: 255
    t.integer  "created_by_id",    limit: 4
    t.integer  "modified_by_id",   limit: 4
  end

  add_index "clients", ["created_by_id"], name: "index_clients_on_created_by_id", using: :btree
  add_index "clients", ["modified_by_id"], name: "index_clients_on_modified_by_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "message",      limit: 65535
    t.integer  "user_id",      limit: 4
    t.integer  "related_id",   limit: 4
    t.string   "related_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["related_id", "related_type"], name: "index_comments_on_related_id_and_related_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "counties", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.integer  "state_id",            limit: 4
    t.string   "search_url",          limit: 255
    t.string   "search_params",       limit: 255
    t.string   "search_method",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone",               limit: 255
    t.string   "fax",                 limit: 255
    t.string   "webpage",             limit: 255
    t.string   "contact_name",        limit: 255
    t.string   "contact_phone",       limit: 255
    t.string   "contact_email",       limit: 255
    t.string   "assessor_webpage",    limit: 255
    t.text     "zip_codes",           limit: 65535
    t.boolean  "co_fee_schedule",     limit: 1,     default: false
    t.boolean  "simplifile",          limit: 1,     default: false
    t.string   "s_contact_name",      limit: 255
    t.string   "s_contact_phone",     limit: 255
    t.string   "s_contact_email",     limit: 255
    t.integer  "checked_out_to_id",   limit: 4
    t.datetime "checked_out_at"
    t.string   "search_template_url", limit: 255
    t.text     "notes",               limit: 65535
  end

  add_index "counties", ["checked_out_to_id"], name: "index_counties_on_checked_out_to_id", using: :btree
  add_index "counties", ["state_id"], name: "index_counties_on_state_id", using: :btree

  create_table "documents", force: :cascade do |t|
    t.integer  "task_id",           limit: 4
    t.string   "file_file_name",    limit: 255
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
    t.string   "file_content_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["task_id"], name: "index_documents_on_task_id", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.integer  "client_id",        limit: 4
    t.string   "address",          limit: 255
    t.string   "city",             limit: 255
    t.integer  "state_id",         limit: 4
    t.string   "zipcode",          limit: 255
    t.integer  "county_id",        limit: 4
    t.datetime "completed_at"
    t.string   "old_owner",        limit: 255
    t.string   "new_owner",        limit: 255
    t.string   "workflow_state",   limit: 255
    t.integer  "requestor_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_number",      limit: 255
    t.date     "close_on"
    t.string   "underwriter_name", limit: 255
    t.boolean  "short_sale",       limit: 1,   default: false
    t.string   "file_type",        limit: 255
    t.integer  "created_by_id",    limit: 4
    t.integer  "modified_by_id",   limit: 4
    t.string   "job_type",         limit: 255, default: "tracking"
  end

  add_index "jobs", ["client_id"], name: "index_jobs_on_client_id", using: :btree
  add_index "jobs", ["county_id"], name: "index_jobs_on_county_id", using: :btree
  add_index "jobs", ["created_by_id"], name: "index_jobs_on_created_by_id", using: :btree
  add_index "jobs", ["modified_by_id"], name: "index_jobs_on_modified_by_id", using: :btree
  add_index "jobs", ["requestor_id"], name: "index_jobs_on_requestor_id", using: :btree

  create_table "lenders", force: :cascade do |t|
    t.string   "name",                     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "average_days_to_complete", limit: 4
  end

  create_table "products", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.text     "description",     limit: 65535
    t.integer  "price_cents",     limit: 4,     default: 0,     null: false
    t.string   "price_currency",  limit: 255,   default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default",         limit: 1,     default: false
    t.boolean  "performs_search", limit: 1,     default: false
    t.integer  "created_by_id",   limit: 4
    t.integer  "modified_by_id",  limit: 4
    t.string   "job_type",        limit: 255
  end

  add_index "products", ["job_type"], name: "index_products_on_job_type", using: :btree

  create_table "search_logs", force: :cascade do |t|
    t.integer  "task_id",    limit: 4
    t.integer  "user_id",    limit: 4
    t.string   "status",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "search_logs", ["task_id"], name: "index_search_logs_on_task_id", using: :btree

  create_table "states", force: :cascade do |t|
    t.string   "name",                        limit: 255
    t.string   "abbreviation",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "time_to_record_days",         limit: 4
    t.boolean  "active",                      limit: 1,   default: false
    t.integer  "time_to_notify_days",         limit: 4,   default: 30
    t.integer  "time_to_dispute_days",        limit: 4,   default: 30
    t.boolean  "can_force_reconveyance",      limit: 1,   default: true
    t.boolean  "allow_sub_of_trustee",        limit: 1,   default: false
    t.boolean  "record_reconveyance_request", limit: 1,   default: false
  end

  create_table "tasks", force: :cascade do |t|
    t.integer  "product_id",               limit: 4
    t.integer  "job_id",                   limit: 4
    t.integer  "price_cents",              limit: 4,   default: 0,     null: false
    t.string   "price_currency",           limit: 255, default: "USD", null: false
    t.string   "workflow_state",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_search_at"
    t.string   "search_url",               limit: 255
    t.date     "due_on"
    t.integer  "created_by_id",            limit: 4
    t.integer  "modified_by_id",           limit: 4
    t.integer  "worker_id",                limit: 4
    t.string   "deed_of_trust_number",     limit: 255
    t.string   "developer",                limit: 255
    t.string   "parcel_number",            limit: 255
    t.string   "beneficiary_name",         limit: 255
    t.integer  "payoff_amount_cents",      limit: 4,   default: 0,     null: false
    t.string   "payoff_amount_currency",   limit: 255, default: "USD", null: false
    t.string   "beneficiary_account",      limit: 255
    t.string   "parcel_legal_description", limit: 255
    t.string   "new_deed_of_trust_number", limit: 255
    t.date     "recorded_on"
    t.integer  "lender_id",                limit: 4
    t.date     "cleared_on"
    t.boolean  "billed",                   limit: 1,   default: false
    t.date     "docs_delivered_on"
    t.boolean  "reconveyance_filed",       limit: 1
    t.string   "type",                     limit: 255
    t.date     "first_notice_sent_on"
    t.date     "second_notice_sent_on"
  end

  add_index "tasks", ["cleared_on"], name: "index_tasks_on_cleared_on", using: :btree
  add_index "tasks", ["created_by_id"], name: "index_tasks_on_created_by_id", using: :btree
  add_index "tasks", ["job_id"], name: "index_tasks_on_job_id", using: :btree
  add_index "tasks", ["lender_id"], name: "index_tasks_on_lender_id", using: :btree
  add_index "tasks", ["modified_by_id"], name: "index_tasks_on_modified_by_id", using: :btree
  add_index "tasks", ["product_id"], name: "index_tasks_on_product_id", using: :btree
  add_index "tasks", ["type"], name: "index_tasks_on_type", using: :btree
  add_index "tasks", ["worker_id"], name: "index_tasks_on_worker_id", using: :btree

  create_table "title_search_caches", force: :cascade do |t|
    t.integer  "task_id",    limit: 4
    t.text     "content",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "title_search_caches", ["task_id"], name: "index_title_search_caches_on_task_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: ""
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "role",                   limit: 4
    t.string   "invitation_token",       limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit",       limit: 4
    t.integer  "invited_by_id",          limit: 4
    t.string   "invited_by_type",        limit: 255
    t.integer  "invitations_count",      limit: 4,   default: 0
    t.integer  "branch_id",              limit: 4
    t.boolean  "primary_contact",        limit: 1,   default: false
    t.boolean  "billing_contact",        limit: 1,   default: false
    t.string   "phone",                  limit: 255
  end

  add_index "users", ["branch_id"], name: "index_users_on_branch_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "zipcodes", force: :cascade do |t|
    t.string   "zipcode",              limit: 255
    t.string   "zip_type",             limit: 255
    t.string   "primary_city",         limit: 255
    t.text     "acceptable_cities",    limit: 65535
    t.text     "unacceptable_cities",  limit: 65535
    t.string   "state",                limit: 255
    t.string   "county",               limit: 255
    t.string   "timezone",             limit: 255
    t.text     "area_codes",           limit: 65535
    t.float    "latitude",             limit: 24
    t.float    "longitude",            limit: 24
    t.string   "world_region",         limit: 255
    t.string   "country",              limit: 255
    t.boolean  "decommissioned",       limit: 1
    t.integer  "estimated_population", limit: 4
    t.text     "notes",                limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "zipcodes", ["zipcode"], name: "index_zipcodes_on_zipcode", using: :btree

end
