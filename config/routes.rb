Rails.application.routes.draw do
  # The site's front page.
  root to: redirect("/proteins/top")

  # Health check for the hosting platform (returns 200 when the app boots).
  get "up" => "rails/health#show", as: :rails_health_check

  # All URLs below are the same as on the original site, so existing links keep working.
  scope "/proteins", controller: :proteins do
    get :top
    get :overview
    get :help
    get :resources
    get :aboutus
    get :help_geneId

    # Browse a sample
    get  :list_protein
    post :search_list_protein_by_gene_id
    post :search_list_protein_by_symbols_or_description

    # Migration-profile chart
    get  :getchart
    post :getchartlist
    get  :getchartslist
    post :getchartslist

    # Single protein search
    get  :key_protein
    get  :search_protein
    post :search_protein
    post :search_key_form_by_gene_id, action: :search_protein
    post :search_key_form_by_symbols_or_description, action: :search_material_protein

    # Multiple protein search
    get  :key_proteins
    post :key_proteins, action: :search_gene_list
  end
end
