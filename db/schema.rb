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

ActiveRecord::Schema.define(version: 20150508123831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "inventories", force: :cascade do |t|
    t.string   "sku"
    t.string   "name"
    t.string   "blurb"
    t.integer  "stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventory_reorders", force: :cascade do |t|
    t.integer  "inventory_id"
    t.integer  "quantity"
    t.date     "estimated_delivery_date"
    t.date     "delivery_date"
    t.string   "status"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "inventory_reorders", ["inventory_id"], name: "index_inventory_reorders_on_inventory_id", using: :btree

  create_table "product_reorders", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "quantity"
    t.date     "estimated_delivery_date"
    t.date     "delivery_date"
    t.string   "status"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "product_reorders", ["product_id"], name: "index_product_reorders_on_product_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "sku"
    t.string   "name"
    t.string   "blurb"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "stock"
  end

end
