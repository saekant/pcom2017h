class Msresult < ApplicationRecord
  belongs_to :material
  belongs_to :protein, optional: true

  # Set on the chart page to pre-check genes that are already plotted.
  attribute :check, :boolean, default: false

  scope :for_gene, ->(gene_id, material_id) { where(gene_id: gene_id, material_id: material_id).order(:gel_no) }

  # Abundance levels (0..3) along the gel, relative to the protein's maximum emPAI
  # in that sample. Used for the coloured bars on the search result pages.
  def self.levels_for(gene_id, material_id)
    values = for_gene(gene_id, material_id).pluck(:empai)
    max = values.compact.max || 0
    values.map do |v|
      v = v.to_f
      if v == 0 then 0
      elsif v <= max / 3 then 1
      elsif v <= max * 2 / 3 then 2
      else 3
      end
    end
  end
end
