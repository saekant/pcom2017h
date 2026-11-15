require "test_helper"

class PagesTest < ActionDispatch::IntegrationTest
  test "static pages" do
    %w[top overview help resources aboutus help_geneId key_protein key_proteins].each do |page|
      get "/proteins/#{page}"
      assert_response :success, page
    end
  end

  test "root redirects to the top page" do
    get "/"
    assert_redirected_to "/proteins/top"
  end

  test "browse a sample" do
    get "/proteins/list_protein", params: { material_id: 3 }
    assert_response :success
    assert_select "#table tbody tr", 2
  end

  test "unknown sample is a 404, not an error" do
    get "/proteins/list_protein", params: { material_id: 999 }
    assert_response :not_found
  end

  test "chart page draws the main gene and extra genes" do
    get "/proteins/getchart", params: { main_gene_id: "AT5G04140", material_id: 3, mode: 1, gene_id_str: "AT5G66570" }
    assert_response :success
    chartsets = JSON.parse(css_select("#chart_container").first["data-chartsets"])
    assert_equal %w[AT5G04140 AT5G66570], chartsets.map { |c| c["gene_id"] }
    assert_equal "1, 2, 3, 4, 5, 6", chartsets.first["xlist"]
    assert_equal "0.0, 0.5, 3.0, 1.0, 0.0, 0.2", chartsets.first["ylist"]
  end

  test "chart without gene_id_str (used to raise an error)" do
    get "/proteins/getchart", params: { main_gene_id: "AT5G04140", material_id: 3 }
    assert_response :success
  end

  test "chart for an unknown gene is a 404" do
    get "/proteins/getchart", params: { main_gene_id: "NOPE", material_id: 3 }
    assert_response :not_found
  end

  test "too many extra genes are capped" do
    get "/proteins/getchart", params: { main_gene_id: "AT5G04140", material_id: 3, gene_id_str: (1..200).map { |i| "G#{i}" }.join(",") }
    assert_response :success
    chartsets = JSON.parse(css_select("#chart_container").first["data-chartsets"])
    assert_equal ProteinsController::MAX_GENES + 1, chartsets.size
  end

  test "peak list for a gel slice, and reCharts with ticked genes" do
    post "/proteins/getchartlist", params: { main_gene_id: "AT5G04140", material_id: 3, gel_no: 2, mode: 1, gene_id_str: "" }
    assert_response :success
    assert_select "#table tbody tr", 2

    post "/proteins/getchartslist", params: { main_gene_id: "AT5G04140", material_id: 3, gel_no: 2, mode: 2,
                                              gene_id: { "AT5G66570" => "1" } }
    assert_response :success
    chartsets = JSON.parse(css_select("#chart_container").first["data-chartsets"])
    assert_equal %w[AT5G04140 AT5G66570], chartsets.map { |c| c["gene_id"] }
  end

  test "single protein search shows Arabidopsis samples and homologs" do
    get "/proteins/search_protein", params: { gene_id: "AT5G04140" }
    assert_response :success
    assert_select "td.material_name a", text: "chloroplast"
    assert_select "td.material_name a", text: "PCC6803 :sll1499"
    assert_select "td.gel60_level3"
  end

  test "single protein search, not found" do
    post "/proteins/search_protein", params: { search_gene_id: "nothing" }
    assert_response :success
    assert_match "was not found", response.body
  end

  test "symbol search across samples (and without parameters)" do
    post "/proteins/search_key_form_by_symbols_or_description", params: { symbols: "GLU", description: "" }
    assert_response :success
    assert_select "#table tbody tr", 1

    post "/proteins/search_list_protein_by_symbols_or_description", params: { material_id: 3 }
    assert_response :success
  end

  test "multiple protein search" do
    post "/proteins/key_proteins", params: { material_id: 3, gene_id_list: "AT5G04140\r\nnope\r\nAT5G66570" }
    assert_response :success
    assert_select "table.mas_table", 2
    assert_match 'Input value "nope"', response.body
  end

  test "security headers" do
    get "/proteins/top"
    csp = response.headers["Content-Security-Policy"]
    assert_includes csp, "script-src 'self'"
    assert_includes csp, "object-src 'none'"
  end
end
