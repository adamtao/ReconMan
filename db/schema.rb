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

ActiveRecord::Schema.define(version: 2020_02_11_182307) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "branches", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "address", limit: 255
    t.string "city", limit: 255
    t.integer "state_id"
    t.string "zipcode", limit: 255
    t.string "phone", limit: 255
    t.integer "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "headquarters"
    t.integer "created_by_id"
    t.integer "modified_by_id"
    t.index ["client_id"], name: "index_branches_on_client_id"
  end

  create_table "client_products", id: :serial, force: :cascade do |t|
    t.integer "client_id"
    t.integer "product_id"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", limit: 255, default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "created_by_id"
    t.integer "modified_by_id"
    t.index ["client_id"], name: "index_client_products_on_client_id"
    t.index ["product_id"], name: "index_client_products_on_product_id"
  end

  create_table "clients", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "client_type", limit: 255
    t.string "website", limit: 255
    t.string "billing_address", limit: 255
    t.string "billing_city", limit: 255
    t.integer "billing_state_id"
    t.string "billing_zipcode", limit: 255
    t.integer "created_by_id"
    t.integer "modified_by_id"
    t.boolean "active", default: true
    t.index ["created_by_id"], name: "index_clients_on_created_by_id"
    t.index ["modified_by_id"], name: "index_clients_on_modified_by_id"
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.text "message"
    t.integer "user_id"
    t.integer "related_id"
    t.string "related_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["related_id", "related_type"], name: "index_comments_on_related_id_and_related_type"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "counties", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "state_id"
    t.string "search_url", limit: 255
    t.string "search_params", limit: 255
    t.string "search_method", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "phone", limit: 255
    t.string "fax", limit: 255
    t.string "webpage", limit: 255
    t.string "contact_name", limit: 255
    t.string "contact_phone", limit: 255
    t.string "contact_email", limit: 255
    t.string "assessor_webpage", limit: 255
    t.text "zip_codes"
    t.boolean "co_fee_schedule"
    t.boolean "simplifile"
    t.string "s_contact_name", limit: 255
    t.string "s_contact_phone", limit: 255
    t.string "s_contact_email", limit: 255
    t.integer "checked_out_to_id"
    t.datetime "checked_out_at"
    t.string "search_template_url", limit: 255
    t.text "notes"
    t.index ["checked_out_to_id"], name: "index_counties_on_checked_out_to_id"
    t.index ["state_id"], name: "index_counties_on_state_id"
  end

  create_table "document_templates", force: :cascade do |t|
    t.string "doctype"
    t.string "layout"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "created_by_id"
    t.integer "modified_by_id"
  end

  create_table "documents", id: :serial, force: :cascade do |t|
    t.integer "task_id"
    t.string "file_file_name", limit: 255
    t.bigint "file_file_size"
    t.datetime "file_updated_at"
    t.string "file_content_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["task_id"], name: "index_documents_on_task_id"
  end

  create_table "jobs", id: :serial, force: :cascade do |t|
    t.integer "client_id"
    t.string "address", limit: 255
    t.string "city", limit: 255
    t.integer "state_id"
    t.string "zipcode", limit: 255
    t.integer "county_id"
    t.datetime "completed_at"
    t.string "old_owner", limit: 255
    t.string "new_owner", limit: 255
    t.string "workflow_state", limit: 255
    t.integer "requestor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "file_number", limit: 255
    t.date "close_on"
    t.string "underwriter_name", limit: 255
    t.boolean "short_sale"
    t.string "file_type", limit: 255
    t.integer "created_by_id"
    t.integer "modified_by_id"
    t.string "job_type", limit: 255, default: "tracking"
    t.index ["client_id"], name: "index_jobs_on_client_id"
    t.index ["county_id"], name: "index_jobs_on_county_id"
    t.index ["created_by_id"], name: "index_jobs_on_created_by_id"
    t.index ["modified_by_id"], name: "index_jobs_on_modified_by_id"
    t.index ["requestor_id"], name: "index_jobs_on_requestor_id"
  end

  create_table "lenders", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "average_days_to_complete"
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "description"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", limit: 255, default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "default"
    t.boolean "performs_search"
    t.integer "created_by_id"
    t.integer "modified_by_id"
    t.string "job_type", limit: 255
    t.index ["job_type"], name: "index_products_on_job_type"
  end

  create_table "search_logs", id: :serial, force: :cascade do |t|
    t.integer "task_id"
    t.integer "user_id"
    t.string "status", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["task_id"], name: "index_search_logs_on_task_id"
  end

  create_table "states", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "abbreviation", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "time_to_record_days"
    t.boolean "active", default: false
    t.integer "time_to_notify_days", default: 30
    t.integer "time_to_dispute_days", default: 30
    t.boolean "can_force_reconveyance", default: true
    t.boolean "allow_sub_of_trustee", default: false
    t.boolean "record_reconveyance_request", default: false
  end

  create_table "tasks", id: :serial, force: :cascade do |t|
    t.integer "product_id"
    t.integer "job_id"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", limit: 255, default: "USD", null: false
    t.string "workflow_state", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_search_at"
    t.string "search_url", limit: 255
    t.date "due_on"
    t.integer "created_by_id"
    t.integer "modified_by_id"
    t.integer "worker_id"
    t.string "deed_of_trust_number", limit: 255
    t.string "developer", limit: 255
    t.string "parcel_number", limit: 255
    t.string "beneficiary_name", limit: 255
    t.bigint "payoff_amount_cents", default: 0, null: false
    t.string "payoff_amount_currency", limit: 255, default: "USD", null: false
    t.string "beneficiary_account", limit: 255
    t.string "parcel_legal_description", limit: 255
    t.string "new_deed_of_trust_number", limit: 255
    t.date "recorded_on"
    t.integer "lender_id"
    t.date "cleared_on"
    t.boolean "billed", default: false
    t.date "docs_delivered_on"
    t.boolean "reconveyance_filed"
    t.string "type", limit: 255
    t.date "first_notice_sent_on"
    t.date "second_notice_sent_on"
    t.index ["cleared_on"], name: "index_tasks_on_cleared_on"
    t.index ["created_by_id"], name: "index_tasks_on_created_by_id"
    t.index ["job_id"], name: "index_tasks_on_job_id"
    t.index ["lender_id"], name: "index_tasks_on_lender_id"
    t.index ["modified_by_id"], name: "index_tasks_on_modified_by_id"
    t.index ["product_id"], name: "index_tasks_on_product_id"
    t.index ["type"], name: "index_tasks_on_type"
    t.index ["worker_id"], name: "index_tasks_on_worker_id"
  end

  create_table "title_search_caches", id: :serial, force: :cascade do |t|
    t.integer "task_id"
    t.text "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["task_id"], name: "index_title_search_caches_on_task_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: ""
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name", limit: 255
    t.string "confirmation_token", limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email", limit: 255
    t.integer "role"
    t.string "invitation_token", limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type", limit: 255
    t.integer "invitations_count", default: 0
    t.integer "branch_id"
    t.boolean "primary_contact"
    t.boolean "billing_contact"
    t.string "phone", limit: 255
    t.string "cell_phone"
    t.index ["branch_id"], name: "index_users_on_branch_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "zipcodes", id: :serial, force: :cascade do |t|
    t.string "zipcode", limit: 255
    t.string "zip_type", limit: 255
    t.string "primary_city", limit: 255
    t.text "acceptable_cities"
    t.text "unacceptable_cities"
    t.string "state", limit: 255
    t.string "county", limit: 255
    t.string "timezone", limit: 255
    t.text "area_codes"
    t.float "latitude"
    t.float "longitude"
    t.string "world_region", limit: 255
    t.string "country", limit: 255
    t.boolean "decommissioned"
    t.integer "estimated_population"
    t.text "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["zipcode"], name: "index_zipcodes_on_zipcode"
  end

end
