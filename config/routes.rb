BarBack::Engine.routes.draw do
  resources :queries, only: [:create, :show, :update]
  root to: 'root#index'
end
