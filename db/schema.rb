# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_05_014915) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "expense_shares", force: :cascade do |t|
    t.integer "expense_id", null: false
    t.integer "user_id", null: false
    t.decimal "amount_owed", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id", "user_id"], name: "index_expense_shares_on_expense_id_and_user_id", unique: true
    t.index ["expense_id"], name: "index_expense_shares_on_expense_id"
    t.index ["user_id"], name: "index_expense_shares_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.integer "paid_by_id", null: false
    t.integer "group_id"
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_expenses_on_group_id"
    t.index ["paid_by_id"], name: "index_expenses_on_paid_by_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "friend_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id", unique: true
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "group_memberships", force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_memberships_on_group_id"
    t.index ["user_id", "group_id"], name: "index_group_memberships_on_user_id_and_group_id", unique: true
    t.index ["user_id"], name: "index_group_memberships_on_user_id"
  end

  create_table "group_messages", force: :cascade do |t|
    t.text "content", null: false
    t.boolean "system", default: false
    t.integer "group_id", null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_messages_on_group_id"
    t.index ["user_id"], name: "index_group_messages_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.integer "created_by", null: false
    t.string "invite_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invite_token"], name: "index_groups_on_invite_token", unique: true
  end

  create_table "payments", force: :cascade do |t|
    t.integer "payer_id", null: false
    t.integer "receiver_id", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payer_id"], name: "index_payments_on_payer_id"
    t.index ["receiver_id"], name: "index_payments_on_receiver_id"
  end

  create_table "settlements", force: :cascade do |t|
    t.integer "payer_id", null: false
    t.integer "payee_id", null: false
    t.integer "group_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_settlements_on_group_id"
    t.index ["payee_id"], name: "index_settlements_on_payee_id"
    t.index ["payer_id"], name: "index_settlements_on_payer_id"
  end

  create_table "transaction_histories", force: :cascade do |t|
    t.integer "payer_id", null: false
    t.integer "receiver_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "settlement_id"
    t.index ["payer_id"], name: "index_transaction_histories_on_payer_id"
    t.index ["receiver_id"], name: "index_transaction_histories_on_receiver_id"
    t.index ["settlement_id"], name: "index_transaction_histories_on_settlement_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "expense_shares", "expenses"
  add_foreign_key "expense_shares", "users"
  add_foreign_key "expenses", "groups"
  add_foreign_key "expenses", "users", column: "paid_by_id"
  add_foreign_key "friendships", "users"
  add_foreign_key "friendships", "users", column: "friend_id"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "users"
  add_foreign_key "group_messages", "groups"
  add_foreign_key "group_messages", "users"
  add_foreign_key "groups", "users", column: "created_by"
  add_foreign_key "payments", "users", column: "payer_id"
  add_foreign_key "payments", "users", column: "receiver_id"
  add_foreign_key "settlements", "groups"
  add_foreign_key "settlements", "users", column: "payee_id"
  add_foreign_key "settlements", "users", column: "payer_id"
  add_foreign_key "transaction_histories", "settlements"
  add_foreign_key "transaction_histories", "users", column: "payer_id"
  add_foreign_key "transaction_histories", "users", column: "receiver_id"
end
