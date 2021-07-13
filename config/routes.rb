BarBack::Engine.routes.draw do
  resource :records, only: [:update]
  resources :shared_queries, only: [:show, :update, :destroy]
  resources :queries, only: [:create, :show, :update, :destroy]
  root to: 'root#index'
end
