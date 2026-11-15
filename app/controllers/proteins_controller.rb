# PCoM-DB: browse and search protein co-migration (BN-PAGE + LC-MS/MS) data.
#
# URLs are kept identical to the original site so that existing links keep working.
class ProteinsController < ApplicationController
  layout "proteins"

  # How many extra genes can be overlaid on one migration-profile chart,
  # and how many gene IDs the multiple search accepts (same limits as the original UI).
  MAX_GENES = 10
  # Gene IDs are short (e.g. AT5G04140, sll1234, Cre01.g000050.t1.1); anything longer is ignored.
  MAX_GENE_ID_LENGTH = 64

  # ---------------------------------------------------------------- static pages

  def top
    render layout: "toph"
  end

  def overview; end
  def help; end
  def resources; end
  def aboutus; end

  def help_geneId
    render layout: "help"
  end

  # ---------------------------------------------------------------- browse a sample

  def list_protein
    @material = Material.find(params[:material_id])
    @list_protein = list_scope(@material)
  end

  def search_list_protein_by_gene_id
    @material = Material.find(params[:material_id])
    @search_gene_id = params[:search_gene_id].to_s
    protein = Protein.find_by_search_input(@search_gene_id)

    if protein
      @list_protein = list_scope(@material).where(gene_id: protein.gene_id)
      @search_gene_id = protein.gene_id
    else
      @list_protein = Msresult.none
    end
    render :list_protein
  end

  def search_list_protein_by_symbols_or_description
    @material = Material.find(params[:material_id])
    @search_symbols = params[:symbols].to_s
    @search_description = params[:description].to_s
    @list_protein = list_scope(@material)
      .where(gene_id: Protein.matching(symbols: @search_symbols, description: @search_description).select(:gene_id))
    render :list_protein
  end

  # ---------------------------------------------------------------- migration-profile chart

  # Chart for one gene (plus optional genes listed in gene_id_str).
  def getchart
    @gene_id_str = params[:gene_id_str].to_s
    build_chart(extra_gene_ids: split_gene_ids(@gene_id_str))
    render :getchartslist
  end

  # Clicked a point on the chart: show the peak list for that gel slice.
  def getchartlist
    load_peak_list
    @gene_id_str = params[:gene_id_str].to_s
    build_chart(extra_gene_ids: split_gene_ids(@gene_id_str))
    render :getchartslist
  end

  # "reCharts": redraw the chart with the genes ticked in the peak list.
  def getchartslist
    load_peak_list
    build_chart(extra_gene_ids: checked_gene_ids)
    @gene_id_str = @chart_gene_ids.join(",")
  end

  # ---------------------------------------------------------------- search

  def key_protein
    @title = "Single protein search"
  end

  def key_proteins
    @title = "Multiple protein search"
    @organisms = Organism.includes(:materials).order(:id)
  end

  # Search by symbols / description across all samples.
  def search_material_protein
    gene_ids = Protein.matching(symbols: params[:symbols], description: params[:description]).select(:gene_id)
    @msresults = Msresult.where(gel_no: 1, gene_id: gene_ids)
      .distinct.select(:gene_id, :protein_id)
      .preload(:protein)
  end

  # Single protein: abundance bars for every sample (and Arabidopsis homologs).
  def search_protein
    @protein =
      if params[:search_gene_id].present?
        Protein.find_by_search_input(params[:search_gene_id])
      elsif params[:gene_id].present?
        Protein.find_by(gene_id: params[:gene_id].to_s)
      end

    unless @protein
      @title = params[:search_gene_id].to_s.presence || params[:gene_id].to_s
      return
    end

    @title = @protein.gene_id
    @organism = @protein.organism
    @arabi_homolog_flg = (@organism == Organism::ARABIDOPSIS)

    # material_id => gene_id to draw for that sample
    keys = materials_with_data(@protein.gene_id).index_with { @protein.gene_id }

    @homolog_gene_ids = {}
    if @arabi_homolog_flg
      Protein.where(arabi_gene_id: @protein.gene_id).order(:id).each do |homolog|
        materials_with_data(homolog.gene_id).each do |material_id|
          keys[material_id] = homolog.gene_id
          @homolog_gene_ids[material_id] = homolog.gene_id
        end
      end
    end

    shown = (Material::ARABIDOPSIS_ROWS + Material::OTHER_ROWS).map(&:id)
    @levels = keys.slice(*shown).to_h { |material_id, gene_id| [ material_id, Msresult.levels_for(gene_id, material_id) ] }
  end

  # Multiple gene IDs within one sample.
  def search_gene_list
    @title = "Multiple protein search result"
    @material = Material.find(params[:material_id])

    inputs = params[:gene_id_list].to_s.split(/\r\n|\r|\n|,/).map(&:strip).reject(&:empty?).first(MAX_GENES)

    @entries = inputs.map do |input|
      protein = Protein.find_by_search_input(input)
      levels = protein ? Msresult.levels_for(protein.gene_id, @material.id) : []
      { input: input, protein: protein, levels: levels }
    end

    found = @entries.select { |e| e[:levels].any? }.map { |e| e[:protein].gene_id }
    @gene_id_str = found.map { |g| "#{g}," }.join
  end

  private

  def list_scope(material)
    material.msresults.where(gel_no: 1).includes(:protein).order(:id)
  end

  def materials_with_data(gene_id)
    Msresult.where(gene_id: gene_id, gel_no: 1).distinct.pluck(:material_id)
  end

  def mode_param
    params[:mode].to_s == "2" ? "2" : "1"
  end

  def clean_gene_id(value)
    id = value.to_s.strip
    id if id.present? && id.length <= MAX_GENE_ID_LENGTH
  end

  def split_gene_ids(str)
    str.to_s.split(",").filter_map { |g| clean_gene_id(g) }
  end

  # Checkboxes in the peak list are submitted as gene_id[GENE]=1 (ticked) / 0.
  def checked_gene_ids
    boxes = params[:gene_id]
    return [] unless boxes.respond_to?(:each_pair)

    ids = []
    boxes.each_pair { |gene, value| ids << gene if value.to_s == "1" }
    ids.filter_map { |g| clean_gene_id(g) }
  end

  # Peak list: every protein detected in the selected gel slice, highest emPAI first.
  def load_peak_list
    @material = Material.find(params[:material_id])
    @selected_gel_no = Integer(params[:gel_no].to_s, exception: false)
    raise ActiveRecord::RecordNotFound unless @selected_gel_no

    @msresults = @material.msresults
      .where(gel_no: @selected_gel_no).where("empai > 0")
      .order(empai: :desc).includes(:protein).to_a
  end

  # Builds @chartsList (one line per gene) and the page header.
  def build_chart(extra_gene_ids:)
    @main_gene_id = clean_gene_id(params[:main_gene_id])
    @material ||= Material.find(params[:material_id])
    @protein = @main_gene_id && Protein.find_by(gene_id: @main_gene_id)
    raise ActiveRecord::RecordNotFound unless @protein

    @mode = mode_param
    @title = "#{@main_gene_id} [ #{@material.material_name} ] "

    @chart_gene_ids = ([ @main_gene_id ] + (extra_gene_ids - [ @main_gene_id ])).uniq.first(MAX_GENES + 1)

    # Tick the genes that are already on the chart.
    @msresults&.each { |r| r.check = @chart_gene_ids.include?(r.gene_id) }

    value_column = @mode == "1" ? :empai : :empai_rt
    xlist = Msresult.for_gene(@main_gene_id, @material.id).pluck(:gel_no).join(", ")

    @chartsList = @chart_gene_ids.map do |gene_id|
      values = Msresult.for_gene(gene_id, @material.id).pluck(value_column).map { |v| format("%.2f", v.to_f).to_f }
      Chartset.new(gene_id: gene_id, xlist: xlist, ylist: values.join(", "))
    end
  end
end
