BarBack::Engine.routes.draw do
  resource :records, only: [:create, :update, :destroy]
  resources :public_queries, only: [:show, :update, :destroy]
  resources :queries, only: [:create, :show, :update, :destroy]
  root to: 'root#index'
  get '*all', to: 'not_found#index'
end
