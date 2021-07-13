BarBack::Engine.routes.draw do
  resource :records, only: [:update, :destroy]
  resources :shared_queries, only: [:show, :update, :destroy]
  resources :queries, only: [:create, :show, :update, :destroy]
  root to: 'root#index'
end
