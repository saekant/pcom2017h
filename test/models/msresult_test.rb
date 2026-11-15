require "test_helper"

class MsresultTest < ActiveSupport::TestCase
  test "levels are relative to the maximum emPAI and ordered by gel slice" do
    # values 0, 0.5, 3.0, 1.0, 0, 0.2 with max 3.0 -> thresholds 1.0 and 2.0
    assert_equal [ 0, 1, 3, 1, 0, 1 ], Msresult.levels_for("AT5G04140", 3)
  end

  test "no data gives no levels" do
    assert_equal [], Msresult.levels_for("AT5G04140", 9)
  end
end

class MsresultOrderTest < ActiveSupport::TestCase
  # Some rows in production are stored out of gel order (e.g. 57, 58, ..., 1, 2).
  # The original site drew them in storage order, shifting the profile; we sort by gel_no.
  test "levels and chart values follow gel_no, not storage order" do
    [ 3, 1, 2 ].each_with_index do |gel, i|
      Msresult.create!(id: 1000 + i, gene_id: "SHIFTED", protein_id: 1, material_id: 9, gel_no: gel, empai: gel == 3 ? 3.0 : 0, empai_rt: 0)
    end
    assert_equal [ 0, 0, 3 ], Msresult.levels_for("SHIFTED", 9)
    assert_equal [ 1, 2, 3 ], Msresult.for_gene("SHIFTED", 9).pluck(:gel_no)
  end
end
