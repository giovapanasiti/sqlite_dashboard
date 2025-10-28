SqliteDashboard::Engine.routes.draw do
  root to: "databases#index"

  # Saved queries
  get 'saved_queries', to: 'databases#saved_queries'
  post 'saved_queries', to: 'databases#create_saved_query'
  get 'saved_queries/:id', to: 'databases#show_saved_query', as: :saved_query
  delete 'saved_queries/:id', to: 'databases#destroy_saved_query'

  # SQL Worksheet
  get 'worksheet', to: 'databases#worksheet', as: :worksheet

  resources :databases, only: [:index, :show] do
    member do
      post :execute_query
      post :export_csv
      post :export_json
      get :tables
      get :table_schema
    end
  end
end