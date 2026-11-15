class Organism < ApplicationRecord
  ARABIDOPSIS = 1

  has_many :materials, -> { order(:id) }
end
