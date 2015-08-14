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

ActiveRecord::Schema.define(version: 20150424152809) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "branches", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.integer  "state_id"
    t.string   "zipcode"
    t.string   "phone"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "headquarters",   default: false
    t.integer  "created_by_id"
    t.integer  "modified_by_id"
  end

  add_index "branches", ["client_id"], name: "index_branches_on_client_id", using: :btree

  create_table "client_products", force: :cascade do |t|
    t.integer  "client_id"
    t.integer  "product_id"
    t.monetize "price",          scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "modified_by_id"
  end

  add_index "client_products", ["client_id"], name: "index_client_products_on_client_id", using: :btree
  add_index "client_products", ["product_id"], name: "index_client_products_on_product_id", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "client_type"
    t.string   "website"
    t.string   "billing_address"
    t.string   "billing_city"
    t.integer  "billing_state_id"
    t.string   "billing_zipcode"
    t.integer  "created_by_id"
    t.integer  "modified_by_id"
  end

  add_index "clients", ["created_by_id"], name: "index_clients_on_created_by_id", using: :btree
  add_index "clients", ["modified_by_id"], name: "index_clients_on_modified_by_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "message"
    t.integer  "user_id"
    t.integer  "related_id"
    t.string   "related_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["related_id", "related_type"], name: "index_comments_on_related_id_and_related_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "counties", force: :cascade do |t|
    t.string   "name"
    t.integer  "state_id"
    t.string   "search_url"
    t.string   "search_params"
    t.string   "search_method"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
    t.string   "fax"
    t.string   "webpage"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.string   "contact_email"
    t.string   "assessor_webpage"
    t.text     "zip_codes"
    t.boolean  "co_fee_schedule",     default: false
    t.boolean  "simplifile",          default: false
    t.string   "s_contact_name"
    t.string   "s_contact_phone"
    t.string   "s_contact_email"
    t.integer  "checked_out_to_id"
    t.datetime "checked_out_at"
    t.string   "search_template_url"
    t.text     "notes"
  end

  add_index "counties", ["checked_out_to_id"], name: "index_counties_on_checked_out_to_id", using: :btree
  add_index "counties", ["state_id"], name: "index_counties_on_state_id", using: :btree

  create_table "documents", force: :cascade do |t|
    t.integer  "task_id"
    t.string   "file_file_name"
    t.integer  "file_file_size",    limit: 8
    t.datetime "file_updated_at"
    t.string   "file_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["task_id"], name: "index_documents_on_task_id", using: :btree

  create_table "jobs", force: :cascade do |t|
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
    t.string   "file_number"
    t.date     "close_on"
    t.string   "underwriter_name"
    t.boolean  "short_sale",       default: false
    t.string   "file_type"
    t.integer  "created_by_id"
    t.integer  "modified_by_id"
    t.string   "job_type",         default: "tracking"
  end

  add_index "jobs", ["client_id"], name: "index_jobs_on_client_id", using: :btree
  add_index "jobs", ["county_id"], name: "index_jobs_on_county_id", using: :btree
  add_index "jobs", ["created_by_id"], name: "index_jobs_on_created_by_id", using: :btree
  add_index "jobs", ["modified_by_id"], name: "index_jobs_on_modified_by_id", using: :btree
  add_index "jobs", ["requestor_id"], name: "index_jobs_on_requestor_id", using: :btree

  create_table "lenders", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "average_days_to_complete"
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.monetize "price",           scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default",                   default: false
    t.boolean  "performs_search",           default: false
    t.integer  "created_by_id"
    t.integer  "modified_by_id"
    t.string   "job_type"
  end

  add_index "products", ["job_type"], name: "index_products_on_job_type", using: :btree

  create_table "search_logs", force: :cascade do |t|
    t.integer  "task_id"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "search_logs", ["task_id"], name: "index_search_logs_on_task_id", using: :btree

  create_table "states", force: :cascade do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "time_to_record_days"
    t.boolean  "active",                      default: false
    t.integer  "time_to_notify_days",         default: 30
    t.integer  "time_to_dispute_days",        default: 30
    t.boolean  "can_force_reconveyance",      default: true
    t.boolean  "allow_sub_of_trustee",        default: false
    t.boolean  "record_reconveyance_request", default: false
  end

  create_table "tasks", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "job_id"
    t.monetize "price",                              scale: 2
    t.string   "workflow_state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_search_at"
    t.string   "search_url"
    t.date     "due_on"
    t.integer  "created_by_id"
    t.integer  "modified_by_id"
    t.integer  "worker_id"
    t.string   "deed_of_trust_number"
    t.string   "developer"
    t.string   "parcel_number"
    t.string   "beneficiary_name"
    t.integer  "payoff_amount_cents",      limit: 8,           default: 0,     null: false
    t.string   "payoff_amount_currency",                       default: "USD", null: false
    t.string   "beneficiary_account"
    t.string   "parcel_legal_description"
    t.string   "new_deed_of_trust_number"
    t.date     "recorded_on"
    t.integer  "lender_id"
    t.date     "cleared_on"
    t.boolean  "billed",                                       default: false
    t.date     "docs_delivered_on"
    t.boolean  "reconveyance_filed"
    t.string   "type"
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
    t.integer  "task_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "title_search_caches", ["task_id"], name: "index_title_search_caches_on_task_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
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
    t.boolean  "primary_contact",        default: false
    t.boolean  "billing_contact",        default: false
    t.string   "phone"
  end

  add_index "users", ["branch_id"], name: "index_users_on_branch_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "zipcodes", force: :cascade do |t|
    t.string   "zipcode"
    t.string   "zip_type"
    t.string   "primary_city"
    t.text     "acceptable_cities"
    t.text     "unacceptable_cities"
    t.string   "state"
    t.string   "county"
    t.string   "timezone"
    t.text     "area_codes"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "world_region"
    t.string   "country"
    t.boolean  "decommissioned"
    t.integer  "estimated_population"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "zipcodes", ["zipcode"], name: "index_zipcodes_on_zipcode", using: :btree

end
