BarBack::Engine.routes.draw do
  resources :queries, only: [:create, :show, :update, :destroy]
  root to: 'root#index'
end
