# Indexes for the lookups the site does on every search / chart page.
# Measured on a copy of the production data: single protein search 280 ms -> 34 ms.
# Only adds indexes; no data is changed.
class AddLookupIndexes < ActiveRecord::Migration[8.1]
  def change
    add_index :msresults, [ :gene_id, :material_id, :gel_no ], if_not_exists: true
    add_index :proteins, :gene_id, if_not_exists: true
    add_index :proteins, :search_gene_id, if_not_exists: true
    add_index :proteins, :arabi_gene_id, if_not_exists: true
  end
end
