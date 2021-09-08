BarBack::Engine.routes.draw do
  resource :records, only: [:create, :update, :destroy]
  resources :public_queries, only: [:show, :update, :destroy]
  resources :queries, only: [:create, :show, :update, :destroy] do
    resources :records, only: [:index, :new]
  end
  root to: 'root#index'
  get '*all', to: 'not_found#index'
end
