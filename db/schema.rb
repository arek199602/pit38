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

ActiveRecord::Schema[8.1].define(version: 2026_06_14_162307) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "transactions", force: :cascade do |t|
    t.string "broker", null: false
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.decimal "fee", precision: 18, scale: 8, default: "0.0", null: false
    t.decimal "price", precision: 18, scale: 8, default: "0.0", null: false
    t.decimal "quantity", precision: 18, scale: 8, default: "0.0", null: false
    t.string "ticker", null: false
    t.date "transacted_on", null: false
    t.string "transaction_type", null: false
    t.datetime "updated_at", null: false
    t.index ["ticker", "transacted_on"], name: "index_transactions_on_ticker_and_transacted_on"
    t.check_constraint "fee >= 0::numeric", name: "transactions_fee_non_negative"
    t.check_constraint "transaction_type::text = ANY (ARRAY['buy'::character varying::text, 'sell'::character varying::text, 'dividend'::character varying::text, 'fee'::character varying::text])", name: "transactions_type_valid"
  end
end
