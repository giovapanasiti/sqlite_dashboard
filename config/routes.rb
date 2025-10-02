SqliteDashboard::Engine.routes.draw do
  root to: "databases#index"

  resources :databases, only: [:index, :show] do
    member do
      post :execute_query
      post :export_csv
      get :tables
      get :table_schema
    end
  end
end