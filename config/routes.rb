Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/proteins/top' => 'proteins#top'
  get '/proteins/overview' => 'proteins#overview'
  get '/proteins/list_protein' => 'proteins#list_protein'
  get '/proteins/help' => 'proteins#help'
   get '/proteins/resources' => 'proteins#resources'
   get '/proteins/aboutus' => 'proteins#aboutus'
    get '/proteins/key_protein' => 'proteins#key_protein'
   get '/proteins/key_proteins' => 'proteins#key_proteins'
   get '/proteins/search_list_protein_by_gene_id' => 'proteins#search_list_protein_by_gene_id'
   get '/proteins/search_list_protein_by_symbols_or_description' => 'proteins#search_list_protein_by_symbols_or_description'
   get '/proteins/getchart' => 'proteins#getchart'
   get '/proteins/getchartslist' => 'proteins#getchartslist'
   post '/proteins/getchartlist' => 'proteins#getchartlist'
   post '/proteins/getchartslist' => 'proteins#getchartslist'

end
