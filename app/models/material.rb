class Material < ApplicationRecord
  belongs_to :organism
  has_many :msresults
  has_many :materialweights, -> { order(:gel_no) }

  # Rows shown on the single-protein search result page.
  # css: width class of the gel bar (matches the original stylesheet).
  Row = Data.define(:id, :label, :css, :organism_id)

  # Arabidopsis samples, in the order the original site shows them.
  ARABIDOPSIS_ROWS = [
    Row.new(id: 3,  label: "chloroplast",   css: "gel60", organism_id: 1),
    Row.new(id: 4,  label: "chloroplast 2", css: "gel60", organism_id: 1),
    Row.new(id: 18, label: "mitochondria",  css: "gel68", organism_id: 1),
    Row.new(id: 10, label: "envelope",      css: "gel68", organism_id: 1),
    Row.new(id: 5,  label: "stroma",        css: "gel60", organism_id: 1),
    Row.new(id: 1,  label: "thylakoid",     css: "gel60", organism_id: 1)
  ].freeze

  # Other organisms (also used as "Homolog" rows for Arabidopsis proteins).
  OTHER_ROWS = [
    Row.new(id: 17, label: "Physcomitrella",      css: "gel68", organism_id: 7),
    Row.new(id: 13, label: "Chlamydomonas",       css: "gel68", organism_id: 3),
    Row.new(id: 9,  label: "PCC6803",             css: "gel60", organism_id: 2),
    Row.new(id: 30, label: "Thermosynechococcus", css: "gel60", organism_id: 13),
    Row.new(id: 15, label: "CCMP1986",            css: "gel48", organism_id: 5),
    Row.new(id: 14, label: "CCMP1375",            css: "gel48", organism_id: 4),
    Row.new(id: 16, label: "CCMP2773",            css: "gel48", organism_id: 6)
  ].freeze

  def display_name
    material_name
  end
end
