class Protein < ApplicationRecord
  # Multiple values are stored separated by "#"; they are displayed separated by ",".
  %i[symbols description arabi_symbols arabi_description].each do |attr|
    define_method(:"#{attr}_tr") { self[attr].to_s.tr("#", ",") }
  end

  def self.search_key(input)
    # Same normalisation the search form applies in the browser:
    # lower-case and remove half/full-width spaces.
    input.to_s.downcase.delete(" 　").strip
  end

  def self.find_by_search_input(input)
    key = search_key(input)
    key.empty? ? nil : find_by(search_gene_id: key)
  end

  # Proteins whose symbols AND description contain the given words (empty = any).
  def self.matching(symbols:, description:)
    where("symbols LIKE ? AND description LIKE ?",
          "%#{sanitize_sql_like(symbols.to_s)}%",
          "%#{sanitize_sql_like(description.to_s)}%")
  end
end
