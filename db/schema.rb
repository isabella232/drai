# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_29_165858) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "aid_applications", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "organization_id", null: false
    t.text "street_address"
    t.text "city"
    t.text "zip_code"
    t.text "phone_number"
    t.text "email"
    t.datetime "submitted_at"
    t.bigint "submitter_id"
    t.string "application_number"
    t.bigint "creator_id", null: false
    t.boolean "receives_calfresh_or_calworks"
    t.boolean "unmet_food"
    t.boolean "unmet_housing"
    t.boolean "unmet_childcare"
    t.boolean "unmet_utilities"
    t.boolean "unmet_transportation"
    t.boolean "unmet_other"
    t.boolean "valid_work_authorization"
    t.boolean "covid19_reduced_work_hours"
    t.boolean "covid19_care_facility_closed"
    t.boolean "covid19_experiencing_symptoms"
    t.boolean "covid19_underlying_health_condition"
    t.boolean "covid19_caregiver"
    t.text "name"
    t.date "birthday"
    t.text "preferred_language"
    t.text "country_of_origin"
    t.text "sexual_orientation"
    t.text "gender"
    t.string "racial_ethnic_identity", default: [], array: true
    t.boolean "sms_consent"
    t.boolean "email_consent"
    t.datetime "approved_at"
    t.bigint "approver_id"
    t.text "apartment_number"
    t.boolean "allow_mailing_address"
    t.text "mailing_street_address"
    t.text "mailing_apartment_number"
    t.text "mailing_city"
    t.text "mailing_state"
    t.text "mailing_zip_code"
    t.boolean "landline"
    t.boolean "attestation"
    t.string "county_name"
    t.boolean "no_cbo_association"
    t.boolean "contact_method_confirmed"
    t.text "card_receipt_method"
    t.datetime "disbursed_at"
    t.bigint "disburser_id"
    t.boolean "confirmed_invalid_email"
    t.datetime "rejected_at"
    t.bigint "rejecter_id"
    t.datetime "paused_at"
    t.datetime "unpaused_at"
    t.bigint "unpauser_id"
    t.boolean "confirmed_invalid_phone_number"
    t.boolean "verified_photo_id"
    t.boolean "verified_proof_of_address"
    t.boolean "verified_covid_impact"
    t.text "verification_case_note"
    t.datetime "verified_at"
    t.bigint "verifier_id"
    t.index ["application_number"], name: "index_aid_applications_on_application_number", unique: true
    t.index ["approver_id"], name: "index_aid_applications_on_approver_id"
    t.index ["creator_id"], name: "index_aid_applications_on_creator_id"
    t.index ["disburser_id"], name: "index_aid_applications_on_disburser_id"
    t.index ["name"], name: "index_aid_applications_on_name", opclass: :gist_trgm_ops, using: :gist
    t.index ["organization_id", "approved_at", "disbursed_at"], name: "index_aid_applications_org_id_approved_at_disbursed_at"
    t.index ["organization_id", "disbursed_at"], name: "index_aid_applications_org_id_disbursed_at"
    t.index ["organization_id", "submitted_at", "approved_at"], name: "index_aid_applications_org_id_submitted_at_approved_at"
    t.index ["organization_id", "submitted_at", "paused_at"], name: "index_aid_applications_org_id_submitted_at_paused_at"
    t.index ["organization_id", "submitted_at"], name: "index_aid_applications_org_id_submitted_at_when_verified", where: "((verified_photo_id = true) AND (verified_proof_of_address = true) AND (verified_covid_impact = true))"
    t.index ["organization_id"], name: "index_aid_applications_on_organization_id"
    t.index ["rejecter_id"], name: "index_aid_applications_on_rejecter_id"
    t.index ["street_address"], name: "index_aid_applications_on_street_address", opclass: :gist_trgm_ops, using: :gist
    t.index ["submitter_id"], name: "index_aid_applications_on_submitter_id"
    t.index ["unpauser_id"], name: "index_aid_applications_on_unpauser_id"
    t.index ["verifier_id"], name: "index_aid_applications_on_verifier_id"
    t.index ["zip_code", "birthday"], name: "index_aid_applications_on_zip_code_and_birthday"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "export_logs", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "organization_id"
    t.bigint "exporter_id"
    t.index ["exporter_id"], name: "index_export_logs_on_exporter_id"
    t.index ["organization_id"], name: "index_export_logs_on_organization_id"
  end

  create_table "ignored_duplicates", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "aid_application_id"
    t.bigint "duplicate_aid_application_id"
    t.bigint "user_id"
    t.index ["aid_application_id", "duplicate_aid_application_id"], name: "index_ignored_duplicates_on_both_ids", unique: true
    t.index ["aid_application_id"], name: "index_ignored_duplicates_on_aid_application_id"
    t.index ["duplicate_aid_application_id"], name: "index_ignored_duplicates_on_duplicate_id"
    t.index ["user_id"], name: "index_ignored_duplicates_on_user_id"
  end

  create_table "message_logs", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "message_id"
    t.text "channel"
    t.text "from"
    t.text "to"
    t.text "subject"
    t.text "body"
    t.text "status"
    t.text "status_code"
    t.text "status_message"
    t.text "messageable_type"
    t.bigint "messageable_id"
    t.index ["message_id"], name: "index_message_logs_on_message_id", unique: true
    t.index ["messageable_type", "messageable_id"], name: "index_message_logs_on_messageable_type_and_messageable_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "name", null: false
    t.integer "users_count", default: 0, null: false
    t.integer "aid_applications_count", default: 0, null: false
    t.integer "total_payment_cards_count", default: 0, null: false
    t.string "county_names", default: [], array: true
    t.string "contact_information"
    t.string "slug"
  end

  create_table "payment_card_orders", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "client_order_number"
    t.bigint "organization_id"
    t.index ["organization_id"], name: "index_payment_card_orders_on_organization_id"
  end

  create_table "payment_cards", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "quote_number"
    t.string "sequence_number"
    t.string "proxy_number"
    t.string "card_number"
    t.string "client_order_number"
    t.string "activation_code"
    t.datetime "blackhawk_activation_code_assigned_at"
    t.bigint "aid_application_id"
    t.index ["aid_application_id"], name: "index_payment_cards_on_aid_application_id", unique: true
    t.index ["proxy_number"], name: "index_payment_cards_on_proxy_number", unique: true
    t.index ["sequence_number"], name: "index_payment_cards_on_sequence_number", unique: true
  end

  create_table "reveal_activation_code_logs", force: :cascade do |t|
    t.bigint "aid_application_id"
    t.bigint "user_id"
    t.index ["aid_application_id"], name: "index_reveal_activation_code_logs_on_aid_application_id"
    t.index ["user_id"], name: "index_reveal_activation_code_logs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.bigint "organization_id"
    t.integer "aid_applications_count", default: 0, null: false
    t.boolean "admin", default: false, null: false
    t.boolean "supervisor", default: false, null: false
    t.bigint "inviter_id"
    t.datetime "deactivated_at"
    t.bigint "aid_applications_created_count", default: 0, null: false
    t.bigint "aid_applications_submitted_count", default: 0, null: false
    t.bigint "aid_applications_approved_count", default: 0, null: false
    t.bigint "aid_applications_disbursed_count", default: 0, null: false
    t.bigint "aid_applications_rejected_count", default: 0, null: false
    t.bigint "aid_applications_unpaused_count", default: 0, null: false
    t.bigint "aid_applications_verified_count", default: 0, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deactivated_at", "id"], name: "index_users_on_deactivated_at_and_id", order: :desc
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["inviter_id"], name: "index_users_on_inviter_id"
    t.index ["organization_id", "deactivated_at", "id"], name: "index_users_on_organization_id_and_deactivated_at_and_id", order: { deactivated_at: :desc, id: :desc }
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "aid_applications", "organizations"
  add_foreign_key "aid_applications", "users", column: "approver_id"
  add_foreign_key "aid_applications", "users", column: "creator_id"
  add_foreign_key "aid_applications", "users", column: "disburser_id"
  add_foreign_key "aid_applications", "users", column: "rejecter_id"
  add_foreign_key "aid_applications", "users", column: "submitter_id"
  add_foreign_key "aid_applications", "users", column: "unpauser_id"
  add_foreign_key "aid_applications", "users", column: "verifier_id"
  add_foreign_key "export_logs", "organizations"
  add_foreign_key "export_logs", "users", column: "exporter_id"
  add_foreign_key "ignored_duplicates", "aid_applications", column: "duplicate_aid_application_id", on_delete: :cascade
  add_foreign_key "ignored_duplicates", "aid_applications", on_delete: :cascade
  add_foreign_key "ignored_duplicates", "users"
  add_foreign_key "payment_card_orders", "organizations"
  add_foreign_key "payment_cards", "aid_applications"
  add_foreign_key "reveal_activation_code_logs", "aid_applications"
  add_foreign_key "reveal_activation_code_logs", "users"
  add_foreign_key "users", "organizations"
  add_foreign_key "users", "users", column: "inviter_id"

  create_view "aid_application_searches", materialized: true, sql_definition: <<-SQL
      SELECT aid_applications.id AS aid_application_id,
      ((((((((((((((((((((((((aid_applications.id || ' '::text) || (aid_applications.application_number)::text) || ' '::text) || replace((aid_applications.application_number)::text, 'APP-'::text, ''::text)) || ' '::text) || regexp_replace((aid_applications.application_number)::text, '[^0-9]'::text, ''::text, 'g'::text)) || ' '::text) || COALESCE(aid_applications.name, ''::text)) || ' '::text) ||
          CASE
              WHEN (aid_applications.birthday IS NOT NULL) THEN to_char((aid_applications.birthday)::timestamp with time zone, 'MM/DD/YYYY'::text)
              ELSE ''::text
          END) || ' '::text) ||
          CASE
              WHEN (aid_applications.birthday IS NOT NULL) THEN to_char((aid_applications.birthday)::timestamp with time zone, 'FMMM/FMDD/YYYY'::text)
              ELSE ''::text
          END) || ' '::text) || COALESCE(aid_applications.street_address, ''::text)) || ' '::text) || COALESCE(aid_applications.city, ''::text)) || ' '::text) || COALESCE(aid_applications.zip_code, ''::text)) || ' '::text) || COALESCE(aid_applications.email, ''::text)) || ' '::text) || COALESCE(aid_applications.phone_number, ''::text)) || ' '::text) || (COALESCE(payment_cards.sequence_number, ''::character varying))::text) AS searchable_data
     FROM (aid_applications
       LEFT JOIN payment_cards ON ((payment_cards.aid_application_id = aid_applications.id)))
    WHERE (aid_applications.application_number IS NOT NULL);
  SQL
  add_index "aid_application_searches", "to_tsvector('english'::regconfig, searchable_data)", name: "index_aid_application_searches_on_searchable_data", using: :gin
  add_index "aid_application_searches", ["aid_application_id"], name: "index_aid_application_searches_on_aid_application_id", unique: true

  create_view "aid_application_waitlists", materialized: true, sql_definition: <<-SQL
      WITH positions AS (
           SELECT aid_applications.id AS aid_application_id,
              aid_applications.organization_id,
              aid_applications.county_name,
              (row_number() OVER (PARTITION BY aid_applications.organization_id ORDER BY aid_applications.id) - organizations.total_payment_cards_count) AS waitlist_position
             FROM (aid_applications
               JOIN organizations ON ((organizations.id = aid_applications.organization_id)))
            WHERE ((aid_applications.submitted_at IS NOT NULL) AND (aid_applications.rejected_at IS NULL))
          )
   SELECT positions.aid_application_id,
      positions.organization_id,
      positions.county_name,
      positions.waitlist_position
     FROM positions
    WHERE (positions.waitlist_position > 0);
  SQL
  add_index "aid_application_waitlists", ["aid_application_id"], name: "index_aid_application_waitlists_on_aid_application_id", unique: true
  add_index "aid_application_waitlists", ["organization_id", "aid_application_id"], name: "index_aid_application_waitlists_on_org_id_and_app_id"
  add_index "aid_application_waitlists", ["organization_id", "county_name"], name: "index_aid_application_waitlists_on_org_id_and_county"

end
