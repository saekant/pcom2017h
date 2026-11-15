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

ActiveRecord::Schema[8.1].define(version: 2015_03_31_045047) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "materials", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "organism_id"
    t.string "material_name", limit: 255
    t.string "grid_disp", limit: 255
    t.index ["organism_id"], name: "index_materials_on_organism_id"
  end

  create_table "materialweights", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "material_id"
    t.bigint "gel_no"
    t.bigint "weight"
    t.index ["material_id"], name: "index_materialweights_on_material_id"
  end

  create_table "msresults", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "material_id"
    t.bigint "protein_id"
    t.string "gene_id", limit: 255
    t.bigint "gel_no"
    t.float "empai", limit: 24
    t.decimal "empai_rt"
    t.integer "peak", limit: 2
    t.index ["material_id"], name: "index_msresults_on_material_id"
    t.index ["protein_id"], name: "index_msresults_on_protein_id"
  end

  create_table "organisms", id: :bigint, default: nil, force: :cascade do |t|
    t.string "organism_name", limit: 255
  end

  create_table "proteins", id: :bigint, default: nil, force: :cascade do |t|
    t.string "gene_id", limit: 256
    t.string "search_gene_id", limit: 256
    t.bigint "organism"
    t.string "symbols", limit: 256
    t.string "description", limit: 1024
    t.decimal "weight"
    t.string "arabi_gene_id", limit: 256
    t.string "arabi_symbols", limit: 256
    t.string "arabi_description", limit: 256
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
