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

ActiveRecord::Schema[7.1].define(version: 2015_03_31_045047) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "materials", id: :integer, default: nil, force: :cascade do |t|
    t.integer "organism_id"
    t.string "material_name", limit: 255
    t.string "grid_disp", limit: 10
  end

  create_table "materialweights", id: :integer, default: nil, force: :cascade do |t|
    t.integer "material_id"
    t.integer "gel_no"
    t.decimal "weight"
  end

  create_table "msresults", id: :integer, default: nil, force: :cascade do |t|
    t.integer "material_id"
    t.integer "protein_id"
    t.string "gene_id", limit: 255
    t.integer "gel_no"
    t.decimal "empai"
    t.decimal "empai_rt"
    t.integer "peak"
  end

  create_table "organisms", id: :integer, default: nil, force: :cascade do |t|
    t.string "organism_name", limit: 255
  end

  create_table "proteins", id: :integer, default: nil, force: :cascade do |t|
    t.string "gene_id", limit: 255
    t.string "search_gene_id", limit: 255
    t.integer "organism"
    t.string "symbols", limit: 255
    t.string "description", limit: 1080
    t.decimal "weight"
    t.string "arabi_gene_id", limit: 255
    t.string "arabi_symbols", limit: 255
    t.string "arabi_description", limit: 255
  end

  add_foreign_key "msresults", "proteins", name: "msresults_protein_id_fkey"
end
