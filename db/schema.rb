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

ActiveRecord::Schema.define(version: 20150331045047) do

  create_table "materials", force: true do |t|
    t.integer "organism_id"
    t.string  "material_name"
    t.string  "grid_disp"
  end

  add_index "materials", ["organism_id"], name: "index_materials_on_organism_id"

  create_table "materialweights", force: true do |t|
    t.integer "material_id"
    t.integer "gel_no"
    t.decimal "weight"
  end

  add_index "materialweights", ["material_id"], name: "index_materialweights_on_material_id"

  create_table "msresults", force: true do |t|
    t.integer "material_id"
    t.integer "protein_id"
    t.string  "gene_id"
    t.integer "gel_no"
    t.decimal "empai"
    t.decimal "empai_rt"
    t.integer "peak"
  end

  add_index "msresults", ["material_id"], name: "index_msresults_on_material_id"
  add_index "msresults", ["protein_id"], name: "index_msresults_on_protein_id"

  create_table "organisms", force: true do |t|
    t.string "organism_name"
  end

  create_table "proteins", force: true do |t|
    t.string  "gene_id"
    t.string  "search_gene_id"
    t.integer "organism"
    t.string  "symbols"
    t.string  "description"
    t.decimal "weight"
    t.string  "arabi_gene_id"
    t.string  "arabi_symbols"
    t.string  "arabi_description"
  end

  add_index "proteins", ["arabi_gene_id"], name: "arabi_gene_id_index"
  add_index "proteins", ["gene_id"], name: "gene_id_index"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
