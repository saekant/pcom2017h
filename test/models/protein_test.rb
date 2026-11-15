require "test_helper"

class ProteinTest < ActiveSupport::TestCase
  test "search input is normalised like the original form (lower case, no spaces)" do
    assert_equal proteins(:glu1), Protein.find_by_search_input(" AT5G 04140　")
  end

  test "symbols are shown comma separated" do
    assert_equal "GLU1,FD-GOGAT", proteins(:glu1).symbols_tr
  end

  test "LIKE wildcards in the search words are treated literally" do
    assert_empty Protein.matching(symbols: "%", description: "")
    assert_includes Protein.matching(symbols: "GLU", description: ""), proteins(:glu1)
  end
end
