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
