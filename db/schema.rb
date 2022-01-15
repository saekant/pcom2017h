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

ActiveRecord::Schema.define(version: 2015_03_31_045047) do

  create_table "materials", force: :cascade do |t|
    t.integer "organism_id"
    t.string "material_name", limit: 255
    t.string "grid_disp", limit: 255
    t.index ["organism_id"], name: "index_materials_on_organism_id"
  end

  create_table "materialweights", force: :cascade do |t|
    t.integer "material_id"
    t.integer "gel_no"
    t.decimal "weight"
    t.index ["material_id"], name: "index_materialweights_on_material_id"
  end

  create_table "msresults", force: :cascade do |t|
    t.integer "material_id"
    t.integer "protein_id"
    t.string "gene_id", limit: 255
    t.integer "gel_no"
    t.decimal "empai"
    t.decimal "empai_rt"
    t.integer "peak"
    t.index ["material_id"], name: "index_msresults_on_material_id"
    t.index ["protein_id"], name: "index_msresults_on_protein_id"
  end

  create_table "organisms", force: :cascade do |t|
    t.string "organism_name", limit: 255
  end

  create_table "proteins", force: :cascade do |t|
    t.string "gene_id", limit: 255
    t.string "search_gene_id", limit: 255
    t.integer "organism"
    t.string "symbols", limit: 255
    t.string "description", limit: 255
    t.decimal "weight"
    t.string "arabi_gene_id", limit: 255
    t.string "arabi_symbols", limit: 255
    t.string "arabi_description", limit: 255
    t.index ["arabi_gene_id"], name: "arabi_gene_id_index"
    t.index ["gene_id"], name: "gene_id_index"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
