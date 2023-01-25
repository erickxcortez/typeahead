Rails.application.routes.draw do
 
  get 'typeahead/:text', to: 'typeahead#get_data', constraints: { text: /.+/ }, as: 'typeahead'
 
  get 'typeahead', to: 'typeahead#get_data'

  match 'typeahead/', to: 'typeahead#update_data', via: :post
end
